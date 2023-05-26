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
    private var methodChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(
            name: "de.hsflensburg.studipadawan.calendarCommunication",
            binaryMessenger: controller.binaryMessenger
        )
        self.methodChannel = methodChannel
        
        CalendarComunicator.shared.initWitMethodChannel(methodChannel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            WidgetCenter.shared.reloadAllTimelines()
            print(#function)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
