//
//  ScheduleResponse.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 02.06.23.
//

import Foundation

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
            let weekday: Int // 1 represents monday, 7 represents sunday
            let locations: [String]?
            let recurrence: Recurrence?
            
            struct Recurrence: Codable {
                let freq: String
                let interval: Int
                let firstOccurrence: Date
                let lastOccurrence: Date
                let excludedDates: [Date]?
                
                private enum CodingKeys: String, CodingKey {
                    case freq = "FREQ"
                    case interval = "INTERVAL"
                    case firstOccurrence = "DTSTART"
                    case lastOccurrence = "UNTIL"
                    case excludedDates = "EXDATES"
                }
            }
        }
    }
}
