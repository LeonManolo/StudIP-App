//
//  CalendarCommunication.swift
//  CalendarCommunication
//
//  Created by Finn Ebeling on 24.05.23.
//

import Foundation

public protocol FlutterMethodChannelAdapter {
    func customInvokeMethod(_ method: String, arguments: Any?, result: @escaping (Any?) -> Void)
}

public class CalendarComunicator {
    public static let shared = CalendarComunicator()
    private var methodChannel: FlutterMethodChannelAdapter?
    
    private init() {}
    
    /// This method will only have an effect on the first call
    public func initWitMethodChannel(_ methodChannel: FlutterMethodChannelAdapter) {
        guard self.methodChannel == nil else { return }
        self.methodChannel = methodChannel
    }
    
    public func loadCalendarEvents(startDate: String?, endDate: String?) {
        print(#function)
        methodChannel?.customInvokeMethod("loadWidgetCalendarEvents", arguments: nil) { result in
            if let str = result as? String {
                fatalError("Got the following response from flutter: " + str)
                NSLog("Got the following response from the flutter code: " + str)
            } else {
                fatalError("Got a response but not a string")
            }
        }
    }
}
