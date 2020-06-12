import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDrhtF_cKxC_PjfTc4RZSGWrO3gOBuQr68")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
