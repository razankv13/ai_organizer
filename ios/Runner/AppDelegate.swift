import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var sharedUrl: String?
  private var sharedText: String?
  private var sharedTitle: String?
  private var sharedType: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Set up Method Channel for share data
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let shareChannel = FlutterMethodChannel(name: "app.organizer.ai/share",
                                           binaryMessenger: controller.binaryMessenger)

    shareChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let self = self else { return }

      switch call.method {
      case "getInitialSharedUrl":
        result(self.sharedUrl)
      case "getInitialSharedText":
        result(self.sharedText)
      case "getInitialSharedData":
        if let url = self.sharedUrl ?? self.sharedText {
          var data: [String: String] = [:]
          data["type"] = self.sharedType ?? "text"
          data["content"] = url
          if let title = self.sharedTitle {
            data["title"] = title
          }
          result(data)
        } else {
          result(nil)
        }
      case "clearSharedData":
        self.sharedUrl = nil
        self.sharedText = nil
        self.sharedTitle = nil
        self.sharedType = nil
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    })

    // Check for shared data from extension
    checkSharedData()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Check if data was shared from Share Extension
  private func checkSharedData() {
    guard let userDefaults = UserDefaults(suiteName: "group.com.example.ai_organizer") else {
      return
    }

    if let sharedContent = userDefaults.string(forKey: "sharedContent") {
      // Determine if it's a URL or text
      if sharedContent.hasPrefix("http://") || sharedContent.hasPrefix("https://") {
        sharedUrl = sharedContent
        sharedType = "url"
      } else {
        sharedText = sharedContent
        sharedType = "text"
      }

      sharedTitle = userDefaults.string(forKey: "sharedTitle")

      // Clear the shared data from UserDefaults
      userDefaults.removeObject(forKey: "sharedContent")
      userDefaults.removeObject(forKey: "sharedTitle")
      userDefaults.synchronize()
    }
  }
}
