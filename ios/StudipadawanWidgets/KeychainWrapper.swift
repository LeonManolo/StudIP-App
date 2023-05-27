//
//  KeychainWrapper.swift
//  Runner
//
//  Created by Finn Ebeling on 26.05.23.
//

import Foundation
import KeychainAccess
import OAuthSwift


class KeychainWrapper {
    static let shared = KeychainWrapper()
    private let keychain: Keychain
    private let oauthClient: OAuth2Swift
    
    private init() {
        oauthClient = OAuth2Swift(
            consumerKey:    "********",
            consumerSecret: "********",
            authorizeUrl: "http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/authorize",
            accessTokenUrl: "http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/token",
            responseType: "code"
        )
        
        keychain = Keychain(service: "flutter_secure_storage_service", accessGroup: "G59VX2UW33.de.hsflensburg.studipadawan.sharedKeychain")
    }
    
    
    func allItems() {
//        keychain.debugDescription
        let rawKeychainContent = keychain[string: "http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/token"] ?? "N/A"
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        guard let keychainRawData = rawKeychainContent.data(using: .utf8),
              let keychainData = try? decoder.decode(KeychainContent.self, from: keychainRawData) else { return }
        
        oauthClient.renewAccessToken(withRefreshToken: keychainData.api.refreshToken) { result in
            switch result {
            case .success(let successValue):
                print(successValue)
            case .failure(let error):
                print(error)
            }
        }
    }
}
