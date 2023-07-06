//
//  ScheduleEntryDataProvider.swift
//  StudipadawanWidgetsExtension
//
//  Created by Finn Ebeling on 28.05.23.
//

import SwiftUI
import WidgetKit
import WidgetDataProvider

enum ScheduleWidgetTimelineEntryError: String, Error {
    case `default` = "Fehler beim Laden des Widgets!\nBitte melde Dich erneut in der App an."
    case unauthorizedResponse = "Ungültige Zugangsdaten!\nBitte melde Dich erneut in der App an."
    case decodingError = "Ungültige API-Daten!\nDie Daten liegen in einem ungültigen Format vor."
    case keychainReadingError = "Keine Zugangsdaten!\nMelde Dich erneut in der App an."
}

struct ScheduleWidgetTimelineEntry: TimelineEntry {
    let date: Date
    let result: Result<[ScheduleItem], ScheduleWidgetTimelineEntryError>
    
    
    static let placeholderFilled = ScheduleWidgetTimelineEntry(
        date: Date(),
        result: .success([
            .init(
                startDate: DateFormatter.hourMinuteFormatter.date(from: "14:30")!,
                endDate: DateFormatter.hourMinuteFormatter.date(from: "15:45")!,
                title: "Softwarearchitektur",
                locations: nil
            )
        ])
    )
    
    static let placeholderEmpty = ScheduleWidgetTimelineEntry(date: Date(), result: .success([]))
    static let placeholderDefaultError = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.default))
    static let placeholderUnauthorizedError = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.unauthorizedResponse))
    static let placeholderDecodingError = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.decodingError))
}

struct ScheduleEntryDataProvider: TimelineProvider {
    let dataProvider: DataProvider
    
    func placeholder(in context: Context) -> ScheduleWidgetTimelineEntry {
        ScheduleWidgetTimelineEntry.placeholderFilled
    }

    func getSnapshot(in context: Context, completion: @escaping (ScheduleWidgetTimelineEntry) -> ()) {
        let currentItems = dataProvider.fetchLocalScheduleItems()
        let entry = ScheduleWidgetTimelineEntry(date: Date(), result: .success(currentItems))
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleWidgetTimelineEntry>) -> ()) {
        Task {
            let entry: ScheduleWidgetTimelineEntry
            do {
                let currentItems = (try await dataProvider.loadRemoteScheduleItems(for: Date()))
                entry = ScheduleWidgetTimelineEntry(date: Date(), result: .success(currentItems))

            } catch {
                print(error)
                if let error = error as? URLError, error.errorCode == 401 {
                    entry = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.unauthorizedResponse))
                } else if let _ = error as? DecodingError {
                    entry = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.decodingError))
                } else if let error = error as? OAuthClientError, case .keychainContentNotReadable = error {
                    entry = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.keychainReadingError))
                } else {
                    entry = ScheduleWidgetTimelineEntry(date: Date(), result: .failure(.default))
                }
            }

            if let nextReloadDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) {
                completion(Timeline(entries: [entry], policy: .after(nextReloadDate)))
            } else {
                completion(Timeline(entries: [entry], policy: .never))
            }
        }
    }
}
