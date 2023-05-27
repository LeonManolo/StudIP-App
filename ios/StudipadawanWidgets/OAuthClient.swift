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

struct EventResponse: Codable {
    let meta: Meta
    let data: [Data]
    
    struct Meta: Codable {
        let page: Page
        
        struct Page: Codable {
            let offset: Int
            let limit: Int
            let total: Int
        }
    }
    
    struct Data: Codable {
        let type: String
        let id: String
        let attributes: Attribute
        
        struct Attribute: Codable {
            let title: String
            let description: String
            let start: Date
            let end: Date
            let categories: [String]
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
    
    func getSchedule() async throws -> [EventResponse.Data] {
        let currentUser: UserResponse = try await get(rawUrlString: "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/me")
        
        let eventRawUrlString = "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/users/\(currentUser.data.id)/events"
        let eventResponse: EventResponse = try await get(rawUrlString: eventRawUrlString, queryItems: [URLQueryItem(name: "page[limit]", value: "150")])
        
        return eventResponse.data
    }
    
    func get<T: Codable>(rawUrlString: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard let rawKeychainContent = keychain[string: tokenUrlString],
              var url = URL(string: rawUrlString) else { throw UserResponseError.generic }
        
        url.append(queryItems: queryItems)
        
        let keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970).decode(KeychainContent.self, from: rawKeychainContent.data(using: .utf8)!)
        
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(keychainContent.api.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try jsonDecoder(dateDecodingStrategy: .iso8601).decode(T.self, from: data)
    }
    
    private func jsonDecoder(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
}
