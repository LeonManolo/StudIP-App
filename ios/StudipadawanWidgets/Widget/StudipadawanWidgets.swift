//
//  StudipadawanWidgets.swift
//  StudipadawanWidgets
//
//  Created by Finn Ebeling on 24.05.23.
//

import WidgetKit
import SwiftUI
import WidgetDataProvider

struct StudipadawanWidgetsSystemMediumView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var maxScheduleItemsToDisplay: Int {
        switch widgetFamily {
        case .systemMedium:
            return 2
        case .systemLarge:
            return 6
        default:
            return 1
        }
    }
    
    var entry: ScheduleWidgetTimelineEntry
    let todayTitleFormatter = DateFormatter.widgetTitleTodayFormatter
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(todayTitleFormatter.string(from: Date()))
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.secondary)
            
            if entry.items.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    Text("Keine Einträge vorhanden")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                    Spacer()
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(entry.items.prefix(maxScheduleItemsToDisplay), id: \.self) { scheduleItem in
                        CalendarEntryView(
                            hourMinuteDateFormatter: DateFormatter.hourMinuteFormatter,
                            scheduleItem: scheduleItem
                        )
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
    }
}

struct StudipadawanWidgets: Widget {
    let kind: String = "StudipadawanWidgets"
    private let dataProvider = DataProvider(
        oauthClient: DefaultOAuthClient.shared,
        cacheProvider: DefaultCacheProvider(userDefaults: UserDefaults(suiteName: "group.de.hs-flensburg.studipadawan") ?? UserDefaults.standard)
    )
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ScheduleEntryDataProvider(dataProvider: dataProvider)
        ) { entry in
            StudipadawanWidgetsSystemMediumView(entry: entry)
                .background(.ultraThinMaterial)
        }
        .configurationDisplayName("Stundenplan")
        .description("Alle Einträge des heutigen Stundenplans")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct StudipadawanWidgets_Previews: PreviewProvider {
    static var previews: some View {
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
