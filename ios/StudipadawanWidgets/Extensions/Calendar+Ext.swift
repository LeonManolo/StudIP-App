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
    
    func today(at hourMinuteString: String) -> Date? {
        guard let hourMinuteDate = DateFormatter.hourMinuteFormatter.date(from: hourMinuteString) else { return nil }
              
        let timeComponents = dateComponents([.hour, .minute], from: hourMinuteDate)
        guard let hourValue = timeComponents.hour,
              let minuteValue = timeComponents.minute,
              let date = date(bySetting: .hour, value: hourValue, of: Date()) else { return nil }
        
        return self.date(bySetting: .minute, value: minuteValue, of: date)
    }
    
    typealias ReccurenceInfo = ScheduleResponse.Data.Attribute.Recurrence
    
    func isDate(in reccurenceInfo: ReccurenceInfo?, date: Date) -> Bool? {
        guard let reccurenceInfo, reccurenceInfo.freq == "WEEKLY" else { return nil }
        guard date >= reccurenceInfo.firstOccurence, date <= reccurenceInfo.lastOccurence else { return false }
        
        var currentOccurence = reccurenceInfo.firstOccurence
        var allOccurences = [Date]()
        while currentOccurence <= reccurenceInfo.lastOccurence {
            allOccurences.append(currentOccurence)
            guard let newOccurence = self.date(byAdding: .weekOfYear, value: reccurenceInfo.interval, to: currentOccurence) else { break }
            currentOccurence = newOccurence
        }
        
        return allOccurences.first { occurence in
            isDate(date, inSameDayAs: occurence) // to avoid issues with different timezones
        } != nil
    }
}
