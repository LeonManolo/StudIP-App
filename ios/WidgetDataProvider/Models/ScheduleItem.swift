//
//  ScheduleItem.swift
//  WidgetDataProvider
//
//  Created by Finn Ebeling on 06.06.23.
//

import Foundation

public struct ScheduleItem: Hashable, Codable {
    public let startDate: Date
    public let endDate: Date
    public let title: String
    public let locations: [String]?
    
    public init(startDate: Date, endDate: Date, title: String, locations: [String]?) {
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.locations = locations
    }
}
