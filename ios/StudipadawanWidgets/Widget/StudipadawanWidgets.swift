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
            
            switch entry.result {
            case .success(let items):
                ItemsView(items: Array(items.prefix(maxScheduleItemsToDisplay)))
                
            case .failure(let error):
                Spacer()
                HStack {
                    Spacer()
                    Text(error.rawValue)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .foregroundColor(.gray)
        .font(.system(size: 16))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
    }
}

private struct ItemsView: View {
    let items: [ScheduleItem]
    
    var body: some View {
        if items.isEmpty {
            Spacer()
            HStack {
                Spacer()
                Text("Heute hast Du keine Termine mehr")
                Spacer()
            }
        } else {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { scheduleItem in
                    CalendarEntryView(
                        hourMinuteDateFormatter: DateFormatter.hourMinuteFormatter,
                        scheduleItem: scheduleItem
                    )
                }
            }
        }
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
                .widgetURL(URL(string: "studipadawan://tappedWidget?homeWidget"))
        }
        .configurationDisplayName("Stundenplan")
        .description("Alle Einträge des heutigen Stundenplans")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct StudipadawanWidgets_Previews: PreviewProvider {
    static var previews: some View {
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholderFilled)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Filled Widget")
        
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholderEmpty)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Empty Widget")
        
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholderDefaultError)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Default Error Widget")
        
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholderUnauthorizedError)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Unauthorized Error Widget")
        
        StudipadawanWidgetsSystemMediumView(entry: ScheduleWidgetTimelineEntry.placeholderDecodingError)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Decoding Error Widget")
    }
}
