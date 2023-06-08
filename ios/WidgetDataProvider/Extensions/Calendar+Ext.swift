//
//  Calendar+Ext.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 27.05.23.
//

import Foundation

extension Calendar {
    static var german: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = .german
        return calendar
    }()
    
    func set(hourMinuteFrom hourMinuteString: String, for baseDate: Date) -> Date? {
        guard let hourMinuteDate = DateFormatter.hourMinuteFormatter.date(from: hourMinuteString) else { return nil }
              
        let timeComponents = dateComponents([.hour, .minute], from: hourMinuteDate)
        guard let hourValue = timeComponents.hour,
              let minuteValue = timeComponents.minute,
              let newBaseDate = self.date(bySetting: .hour, value: hourValue, of: Calendar.german.startOfDay(for: baseDate)) else { return nil }
        
        return self.date(bySetting: .minute, value: minuteValue, of: newBaseDate)
    }
    
    typealias ReccurenceInfo = ScheduleResponse.Data.Attribute.Recurrence
    
    func `is`(date: Date, in reccurenceInfo: ReccurenceInfo?) -> Bool? {
        guard let reccurenceInfo, reccurenceInfo.freq == "WEEKLY" else { return nil }
        guard date >= reccurenceInfo.firstOccurrence, date <= reccurenceInfo.lastOccurrence else { return false }
        
        var currentOccurrence = reccurenceInfo.firstOccurrence
        var allOccurrences = [Date]()
        let excludedDates = reccurenceInfo.excludedDates ?? []
        
        while currentOccurrence <= reccurenceInfo.lastOccurrence {
            if !excludedDates.contains(currentOccurrence) {
                allOccurrences.append(currentOccurrence)
            }
            
            guard let newOccurrence = self.date(byAdding: .weekOfYear, value: reccurenceInfo.interval, to: currentOccurrence) else { break }
            currentOccurrence = newOccurrence
        }
        
        return allOccurrences.contains(date)
    }
}
