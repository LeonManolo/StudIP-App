//
//  OAuthClient.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 27.05.23.
//

import Foundation
import KeychainAccess

/*
 {
     "api": {
         "token_type": "Bearer",
         "expires_in": 3600,
         "access_token": "...",
         "refresh_token": "...",
         "scope": [
             "api"
         ],
         "expiration_date": 1685131006643,
         "http_status_code": 200
     }
 }
 */

struct KeychainContent: Codable {
    let api: API
    
    struct API: Codable {
        let accessToken: String
        let refreshToken: String
        let scope: [String]
        let expirationDate: Date
        let httpStatusCode: Int
    }
}

struct UserResponse: Codable {
    let data: Data
    
    struct Data: Codable {
        let id: String
    }
}

enum UserResponseError: Error {
    case generic
}

struct ScheduleResponse: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let type: String
        let id: String
        let attributes: Attribute
        
        struct Attribute: Codable {
            let title: String
            let description: String?
            let start: String
            let end: String
            let weekday: Weekday
            let locations: [String]?
            let recurrence: Recurrence?
            
            enum Weekday: Int, Codable {
                case monday = 1
                case tuesday, wednesday, thursday, friday, saturday, sunday
            }
            
            struct Recurrence: Codable {
                let freq: String
                let interval: Int
                let firstOccurence: Date
                let lastOccurence: Date
                let excludedDates: [Date]?
                
                private enum CodingKeys: String, CodingKey {
                    case freq = "FREQ"
                    case interval = "INTERVAL"
                    case firstOccurence = "DTSTART"
                    case lastOccurence = "UNTIL"
                    case excludedDates = "EXDATES"
                }
            }
        }
    }
}



class OAuthClient {
    static let shared = OAuthClient(
        tokenUrlString: "http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/token",
        clientId: "5",
        keychain: Keychain(service: "flutter_secure_storage_service", accessGroup: "G59VX2UW33.de.hsflensburg.studipadawan.sharedKeychain"),
        baseUrl: "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/"
    )
    
    let tokenUrlString: String
    let clientId: String
    let keychain: Keychain
    let baseUrl: String
    
//    private var baseComponents: URLComponents {
//        var components = URLComponents()
//        components.scheme = "http"
//        components.host = baseUrl
//        return components
//    }

    init(tokenUrlString: String, clientId: String, keychain: Keychain, baseUrl: String) {
        self.tokenUrlString = tokenUrlString
        self.clientId = clientId
        self.keychain = keychain
        self.baseUrl = baseUrl
    }
    
    func getSchedule() async throws -> [ScheduleResponse.Data] {
        let currentUser: UserResponse = try await get(rawUrlString: "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/me")
        
        let eventRawUrlString = "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/\(currentUser.data.id)/schedule"
        let scheduleResponse: ScheduleResponse = try await get(rawUrlString: eventRawUrlString)
        
        let scheduleEntryData = scheduleResponse.data.first { data in
            data.attributes.recurrence?.firstOccurence != nil
        }
        
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "de_DE")
        print(scheduleEntryData?.attributes.title)
        print(calendar.dateComponents([.weekday], from: scheduleEntryData!.attributes.recurrence!.firstOccurence).weekday)
        
        return []
    }
    
    func get<T: Codable>(rawUrlString: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard let rawKeychainContent = keychain[string: tokenUrlString] else { throw UserResponseError.generic }
        var keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970)
            .decode(KeychainContent.self, from: rawKeychainContent.data(using: .utf8)!)
        
        if keychainContent.api.expirationDate < Date() {
            try await refreshToken()
            // if token has been refreshed, new keychainContent must be used
            guard let rawKeychainContent = keychain[string: tokenUrlString] else { throw UserResponseError.generic }
            keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970)
                .decode(KeychainContent.self, from: rawKeychainContent.data(using: .utf8)!)
        }
        
        guard var url = URL(string: rawUrlString) else { throw UserResponseError.generic }
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(keychainContent.api.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try jsonDecoder(dateDecodingStrategy: .iso8601).decode(T.self, from: data)
    }
    
    private func refreshToken() async throws {
        guard let rawKeychainContent = keychain[string: tokenUrlString], let tokenUrl = URL(string: tokenUrlString) else { throw UserResponseError.generic }
        let keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970).decode(KeychainContent.self, from: rawKeychainContent.data(using: .utf8)!)
        
        let currentRefreshToken = keychainContent.api.refreshToken
        var bodyParamenters = URLComponents()
        bodyParamenters.queryItems = [
            URLQueryItem(name: "refresh_token", value: currentRefreshToken),
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "client_id", value: clientId)
        ]
        
        var request = URLRequest(url: tokenUrl)
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.httpBody = bodyParamenters.query?.data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let refreshResponse = try jsonDecoder().decode(RefreshTokenResponse.self, from: data)
        
        guard let newExpirationDate = Calendar.german.date(
            byAdding: .second,
            value: refreshResponse.expiresIn,
            to: Date()
        ) else { return }
        
        let newKeychainContent = KeychainContent(api: .init(
            accessToken: refreshResponse.accessToken,
            refreshToken: refreshResponse.refreshToken,
            scope: keychainContent.api.scope,
            expirationDate: newExpirationDate,
            httpStatusCode: 200
        ))
        
        keychain[string: self.tokenUrlString] = String(
            data: try jsonEncoder().encode(newKeychainContent),
            encoding: .utf8
        )
    }
    
    private func jsonDecoder(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
    
    private func jsonEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .custom { date, encoder in
            // if using .millisecondsSince1970, then it's encoded using Double, which is not compatible with flutter library
            var container = encoder.singleValueContainer()
            try container.encode(Int64(date.timeIntervalSince1970 * 1000))
        }
        return encoder
    }
}
