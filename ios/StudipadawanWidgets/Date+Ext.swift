//
//  Date+Ext.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 27.05.23.
//

import Foundation

extension Date {
    // https://stackoverflow.com/a/35687720
    func startOfWeek(using calendar: Calendar = .german) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}
