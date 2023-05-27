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
        print(#function)
        return SimpleEntry(date: Date(), text: "some dummy text")
    }

    
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        KeychainWrapper.shared.allItems()
        print(Date().startOfWeek())
        Task {
            do {
                let res = try await OAuthClient.shared.getSchedule()
                print(res)
            } catch {
                print(error)
            }
        }
        
        let entry = SimpleEntry(date: Date(), text: "some value")
        completion(entry)
        
//        completion(SimpleEntry(date: Date(), text: "some number: \(Int.random(in: 0...100000))"))
//        CalendarComunicator.shared.loadCalendarEvents(startDate: Date.now.ISO8601Format()) { updatedDate in
//            let entry = SimpleEntry(date: Date(), text: updatedDate)
//
//            completion(entry)
//        }
        
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print(#function)
        getSnapshot(in: context) { entry in
            completion(Timeline(entries: [entry], policy: .never))
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
        .font(.callout)
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
