//
//  OAuthClient.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 27.05.23.
//

import Foundation
import KeychainAccess

enum OAuthClientError: Error {
    case keychainContentNotReadable(key: String)
    case invalidUrlString(url: String)
}

class OAuthClient {
    static let shared = OAuthClient(
        tokenUrlString: "http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/token",
        clientId: "5",
        keychain: Keychain(service: "flutter_secure_storage_service", accessGroup: "N9XSF4AL84.de.hs-flensburg.studipadawan.sharedKeychain"),
        baseUrl: "http://miezhaus.feste-ip.net:55109/jsonapi.php/v1/"
    )
    
    let tokenUrlString: String
    let clientId: String
    let keychain: Keychain
    let baseUrl: String
    
    init(tokenUrlString: String, clientId: String, keychain: Keychain, baseUrl: String) {
        self.tokenUrlString = tokenUrlString
        self.clientId = clientId
        self.keychain = keychain
        self.baseUrl = baseUrl
    }
    
    func get<T: Codable>(rawUrlString: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard let rawKeychainContentData = keychain[string: tokenUrlString]?.data(using: .utf8) else { throw OAuthClientError.keychainContentNotReadable(key: tokenUrlString) }
        var keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970).decode(KeychainContent.self, from: rawKeychainContentData)
        
        if keychainContent.api.expirationDate < Date() {
            try await refreshToken()
            // if token has been refreshed, keychainContent must be updated
            guard let rawKeychainContentData = keychain[string: tokenUrlString]?.data(using: .utf8) else { throw OAuthClientError.keychainContentNotReadable(key: tokenUrlString) }
            keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970).decode(KeychainContent.self, from: rawKeychainContentData)
        }
        
        guard var url = URL(string: rawUrlString) else { throw OAuthClientError.invalidUrlString(url: rawUrlString) }
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(keychainContent.api.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try jsonDecoder(dateDecodingStrategy: .iso8601).decode(T.self, from: data)
    }
    
    private func refreshToken() async throws {
        guard let rawKeychainContentData = keychain[string: tokenUrlString]?.data(using: .utf8), let tokenUrl = URL(string: tokenUrlString) else { throw OAuthClientError.keychainContentNotReadable(key: tokenUrlString) }
        let keychainContent = try jsonDecoder(dateDecodingStrategy: .millisecondsSince1970).decode(KeychainContent.self, from: rawKeychainContentData)
        
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
