//
//  StudipadawanWidgets.swift
//  StudipadawanWidgets
//
//  Created by Finn Ebeling on 24.05.23.
//

import WidgetKit
import SwiftUI
import CalendarCommunication

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "some dummy text")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        DispatchQueue.main.async {
            CalendarComunicator.shared.loadCalendarEvents(startDate: Date.now.ISO8601Format()) { updatedDate in
                let items = updatedDate.split(separator: ",")
                let entry = SimpleEntry(date: Date(), text: updatedDate)
                
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        DispatchQueue.main.async {
            CalendarComunicator.shared.loadCalendarEvents(startDate: Date.now.ISO8601Format()) { updatedDate in
                let items = updatedDate.split(separator: ",")
                
                let entryDate = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
                let entry = SimpleEntry(date: entryDate, text: updatedDate)
                
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct StudipadawanWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.date, style: .time)
            Text(entry.text)
        }
    }
}

struct StudipadawanWidgets: Widget {
    let kind: String = "StudipadawanWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            StudipadawanWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StudipadawanWidgets_Previews: PreviewProvider {
    static var previews: some View {
        StudipadawanWidgetsEntryView(entry: SimpleEntry(date: Date(), text: "some dummy text"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
