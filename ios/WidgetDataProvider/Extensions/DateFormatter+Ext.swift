//
//  DateFormatter+Ext.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import Foundation

public extension DateFormatter {
    static let hourMinuteFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = .german
        return dateFormatter
    }()
    
    static let widgetTitleTodayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d. MMM"
        dateFormatter.timeZone = .german
        return dateFormatter
    }()
}
