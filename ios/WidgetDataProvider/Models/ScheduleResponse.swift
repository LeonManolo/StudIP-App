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
