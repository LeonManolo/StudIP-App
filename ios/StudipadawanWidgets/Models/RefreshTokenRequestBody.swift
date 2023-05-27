//
//  RefreshTokenRequest.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 27.05.23.
//

import Foundation

struct RefreshTokenRequestBody: Codable {
    let refreshToken: String
    let grantType: String
    let clientId: String
}
