//
//  KeychainContent.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 02.06.23.
//

import Foundation

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
