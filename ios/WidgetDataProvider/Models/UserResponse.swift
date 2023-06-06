//
//  UserResponse.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 02.06.23.
//

import Foundation

struct UserResponse: Codable {
    let data: Data
    
    struct Data: Codable {
        let id: String
    }
}
