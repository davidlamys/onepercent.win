import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        if let controller = self.window.rootViewController as? FlutterViewController  {
            let batteryChannel = FlutterMethodChannel(name: "dexterx.dev/flutter_local_notifications_example",
                                                      binaryMessenger: controller.binaryMessenger)
            batteryChannel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                // Note: this method is invoked on the UI thread.
                // Handle battery messages.
                if (call.method == "getBatteryLevel") {
                    let tz = TimeZone.current
                    result(tz.identifier)
                }
            })
        }
                
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
