import UIKit
import Flutter
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Set task keys to check entry register digital point
    WorkmanagerPlugin.registerTask(withIdentifier: "verificar-ponto-entry1Date-Task")
    WorkmanagerPlugin.registerTask(withIdentifier: "verificar-ponto-out1Date-Task")
    WorkmanagerPlugin.registerTask(withIdentifier: "verificar-ponto-entry2Date-Task")
    WorkmanagerPlugin.registerTask(withIdentifier: "verificar-ponto-out2Date-Task")

    // Set time interval for Workmanager plugin
    UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(3600))

    // Make other plugins available during a background fetch
      WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
        }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}