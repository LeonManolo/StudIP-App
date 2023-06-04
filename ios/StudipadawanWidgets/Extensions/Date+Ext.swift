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
    
    // https://stackoverflow.com/a/51113983
    var weekday: Int? {
        guard let rawWeekday = Calendar.german.dateComponents([.weekday], from: Date()).weekday else { return nil }
        
        return rawWeekday == 1 ? 7 : rawWeekday - 1
    }
}
