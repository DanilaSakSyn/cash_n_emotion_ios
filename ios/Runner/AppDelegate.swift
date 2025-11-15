import Flutter
import UIKit
import flutter_local_notifications
import AppTrackingTransparency
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
         if #available(iOS 14, *) {
             ATTTrackingDialougue()
        }
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.yourapp/native_methods",
                                          binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "callSwiftMethodWithParams":
                if let arguments = call.arguments as? [String: Any] {
                    self.yourSwiftMethodWithParams( params: arguments)
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        })

      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func ATTTrackingDialougue() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        }
    
    private func yourSwiftMethodWithParams(params: [String: Any]) {
            print("Swift method called with parameters: \(params)")
            
          
            
            // Вызов системных функций iOS
            if let urlString = params["url"] as? String,
               let url = URL(string: urlString) {
                print("Swift method called with parameters: url")
                print(url)
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        print("URL opened successfully")
                    } else {
                        print("Failed to open URL")
                    }
                }
            }
            
        }
   
}

