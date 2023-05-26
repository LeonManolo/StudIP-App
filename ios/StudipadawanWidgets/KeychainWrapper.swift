//
//  KeychainWrapper.swift
//  Runner
//
//  Created by Finn Ebeling on 26.05.23.
//

import Foundation
import KeychainAccess

class KeychainWrapper {
    static let shared = KeychainWrapper()
    private let keychain: Keychain
    
    private init() {
        keychain = Keychain(service: "flutter_secure_storage_service", accessGroup: "G59VX2UW33.de.hsflensburg.studipadawan.sharedKeychain")
        // Key für Keychain: http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/token
    }
    
    func allItems() -> String {
//        keychain.debugDescription
        keychain[string: "http://miezhaus.feste-ip.net:55109/dispatch.php/api/oauth2/token"] ?? "N/A"
    }
}
