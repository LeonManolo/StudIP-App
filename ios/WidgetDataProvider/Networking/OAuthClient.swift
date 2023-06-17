//
//  OAuthClient.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 27.05.23.
//

import Foundation
import KeychainAccess

public enum OAuthClientError: Error {
    case keychainContentNotReadable(key: String)
    case invalidUrlString(url: String)
}

public protocol OAuthClient {
    func get<T: Codable>(rawUrlString: String, queryItems: [URLQueryItem]) async throws -> T
}

public class DefaultOAuthClient: OAuthClient {
    public static let shared = DefaultOAuthClient(
        tokenUrlString: "http://studip.miezhaus.net/dispatch.php/api/oauth2/token",
        clientId: "5",
        keychain: Keychain(service: "flutter_secure_storage_service", accessGroup: "N9XSF4AL84.de.hs-flensburg.studipadawan.sharedKeychain"),
        baseUrl: "http://studip.miezhaus.net/jsonapi.php/v1/"
    )
    
    private let tokenUrlString: String
    private let clientId: String
    private let keychain: Keychain
    private let baseUrl: String
    
    public init(tokenUrlString: String, clientId: String, keychain: Keychain, baseUrl: String) {
        self.tokenUrlString = tokenUrlString
        self.clientId = clientId
        self.keychain = keychain
        self.baseUrl = baseUrl
    }
    
    /// Generic method to execute a GET Request for the given `rawUrlString` with the passed `queryItems`
    /// If a token refresh is required, it's automatically executed before the GET-Request.
    /// If no Refresh- and/or Access-Token is present, this method fails.
    /// - Parameters:
    ///   - rawUrlString: Full URL-String
    ///   - queryItems: Query-Items to use
    /// - Returns: Decoded Result based on `T`
    public func get<T: Codable>(rawUrlString: String, queryItems: [URLQueryItem] = []) async throws -> T {
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
    
    /// Refreshes the Access-Token with the stored Refresh-Token. After a successfull refresh both tokens are updated and stored in the keychain.
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
