import UIKit
import Flutter
import CalendarCommunication
import WidgetKit

extension FlutterMethodChannel: FlutterMethodChannelAdapter {
    public func customInvokeMethod(_ method: String, arguments: Any?, result: @escaping (Any?) -> Void) {
        self.invokeMethod(method, arguments: arguments, result: result)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            let methodChannel = FlutterMethodChannel(
                name: "de.hsflensburg.studipadawan.calendarCommunication",
                binaryMessenger: controller.binaryMessenger
            )
            
            methodChannel.invokeMethod("loadWidgetCalendarEvents", arguments: nil) { result in
                fatalError((result as? String) ?? "Result cant be converted to string")
                if let str = result as? String {
                    print(str)
                } else {
                    print("some other result")
                }
            }
        }
        
       
//        CalendarComunicator.shared.initWitMethodChannel(methodChannel)
        
        GeneratedPluginRegistrant.register(with: self)
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
