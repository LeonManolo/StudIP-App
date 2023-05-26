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
    
    public func initWitMethodChannel(_ methodChannel: FlutterMethodChannelAdapter) {
        self.methodChannel = methodChannel
    }
    
    public func loadCalendarEvents(startDate: String, completion: @escaping (String) -> Void) {
        if self.methodChannel == nil {
            completion("methodChannel is nil \(Int.random(in: 0...50000))")
        } else {
            completion("methodChannel is not nil \(Int.random(in: 51000...100000))")
        }
        
        
        DispatchQueue.main.async {
            
//            fatalError("methodChannel is nil: \(self.methodChannel == nil)")
//            completion("some number: \(Int.random(in: 0...100000))")
//            self.methodChannel.customInvokeMethod("loadWidgetCalendarEvents", arguments: nil) { result in
//                if let str = result as? String {
//                    completion(str)
//                    NSLog("Got the following response from the flutter code: " + str)
//                } else {
//                    completion("Response not a string")
//                    NSLog("Response not a string")
//                }
//            }
        }
    }
}
