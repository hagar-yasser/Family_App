import UIKit
import Flutter
import UserNotifications
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      application.applicationIconBadgeNumber = 0 // For Clear Badge Counts
      let center = UNUserNotificationCenter.current()
      center.removeAllDeliveredNotifications() // To remove all delivered notifications
      center.removeAllPendingNotificationRequests()
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
