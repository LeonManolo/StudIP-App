//
//  ScheduleEntryDataProvider.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import SwiftUI
import WidgetKit
import WidgetDataProvider

struct ScheduleWidgetTimelineEntry: TimelineEntry {
    let date: Date
    let items: [ScheduleItem]
    
    static let placeholder = ScheduleWidgetTimelineEntry(
        date: Date(),
        items: [
            .init(
                startDate: DateFormatter.hourMinuteFormatter.date(from: "14:30")!,
                endDate: DateFormatter.hourMinuteFormatter.date(from: "15:45")!,
                title: "Softwarearchitektur",
                locations: nil
            )
        ]
    )
}

struct ScheduleEntryDataProvider: TimelineProvider {
    let dataProvider: DataProvider
    
    func placeholder(in context: Context) -> ScheduleWidgetTimelineEntry {
        ScheduleWidgetTimelineEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleWidgetTimelineEntry) -> ()) {
        let currentItems = dataProvider.fetchLocalScheduleItems()
        let entry = ScheduleWidgetTimelineEntry(date: Date(), items: currentItems)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleWidgetTimelineEntry>) -> ()) {
        Task {
            let currentItems = (try? await dataProvider.loadRemoteScheduleItems(for: Date())) ?? []
            let entry = ScheduleWidgetTimelineEntry(date: Date(), items: currentItems)

            if let nextReloadDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) {
                completion(Timeline(entries: [entry], policy: .after(nextReloadDate)))
            } else {
                completion(Timeline(entries: [entry], policy: .never))
            }
        }
    }
}
