//
//  CalendarEntryVie.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 02.06.23.
//

import SwiftUI

struct CalendarEntryView: View {
    let hourMinuteDateFormatter: DateFormatter
    let scheduleItem: ScheduleItem
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.scheduleEntryContrast)
                .frame(width: 4)
            
            VStack(alignment: .leading) {
                Text(scheduleItem.title)
                    .font(.system(size: 14))
                    .lineLimit(1)
                
                Text("\(hourMinuteDateFormatter.string(from: scheduleItem.startDate)) - \(hourMinuteDateFormatter.string(from: scheduleItem.endDate))")
                    .font(.system(size: 12))
            }
            .padding(5)
            
            Spacer()
        }
        .frame(height: 40)
        .foregroundColor(.scheduleEntryContrast)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.scheduleEntryBackground)
        )
    }
}

struct CalendarEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarEntryView(
            hourMinuteDateFormatter: DateFormatter.hourMinuteFormatter,
            scheduleItem: ScheduleWidgetTimelineEntry.placeholder.items[0]
        )
    }
}
