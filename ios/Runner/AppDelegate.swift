import Flutter
import UIKit
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        // Register a periodic task with 20 minutes frequency. The frequency is in seconds.
        WorkmanagerPlugin.registerPeriodicTask(
            withIdentifier: "com.zeykafx.bytesized_news.btNewsBgFetch",
            frequency: NSNumber(value: 8 * 60 * 60 * 60))
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
