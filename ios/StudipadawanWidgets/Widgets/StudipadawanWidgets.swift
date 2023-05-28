//
//  StudipadawanWidgets.swift
//  StudipadawanWidgets
//
//  Created by Finn Ebeling on 24.05.23.
//

import WidgetKit
import SwiftUI
import CalendarCommunication

struct StudipadawanWidgetsSystemMediumView : View {
    var entry: ScheduleWidgetTimelineEntry

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(entry.items, id: \.self) { scheduleItem in
                    VStack(alignment: .leading) {
                        Text(scheduleItem.title)
                        Text("\(dateFormatter.string(from: scheduleItem.startDate)) Uhr - \(dateFormatter.string(from: scheduleItem.endDate)) Uhr")
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
        }
        .padding(28)
    }
}

struct StudipadawanWidgets: Widget {
    let kind: String = "StudipadawanWidgets"
    private let dataProvider = DataProvider(
        oauthClient: OAuthClient.shared,
        cacheProvider: CacheProvider(userDefaults: UserDefaults(suiteName: "") ?? UserDefaults.standard)
    )

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ScheduleEntryDataProvider(dataProvider: dataProvider)
        ) { entry in
            StudipadawanWidgetsSystemMediumView(entry: entry)
        }
        .configurationDisplayName("Stundenplan")
        .description("Alle Einträge des heutigen Stundenplans")
        .supportedFamilies([.systemMedium])
    }
}

struct StudipadawanWidgets_Previews: PreviewProvider {
    static var previews: some View {
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
