import UIKit
import Flutter
import WebKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  var webView: WKWebView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

      let controller = window?.rootViewController as! FlutterViewController
      let urlLauncherChannel = FlutterMethodChannel(name: "com.example.app/url_launcher",
                                                    binaryMessenger: controller.binaryMessenger)

      urlLauncherChannel.setMethodCallHandler { (call, result) in
          if call.method == "openUrl" {
              guard let args = call.arguments as? [String: Any],
                    let urlString = args["url"] as? String,
                    let url = URL(string: urlString) else {
                  result(FlutterError(code: "INVALID_URL",
                                      message: "URL inválida ou ausente.",
                                      details: nil))
                  return
              }
              let headers = args["headers"] as? [String: String] ?? [:]
              self.openUrlWithHeaders(url: url, headers: headers, result: result)
          } else {
              result(FlutterMethodNotImplemented)
          }
      }

      GeneratedPluginRegistrant.register(with: self)

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func openUrlWithHeaders(url: URL, headers: [String: String], result: @escaping FlutterResult) {
      DispatchQueue.main.async {
          let webViewController = WebViewController()
          webViewController.url = url
          webViewController.headers = headers

          let navigationController = UINavigationController(rootViewController: webViewController)
          navigationController.modalPresentationStyle = .fullScreen

          self.window?.rootViewController?.present(navigationController, animated: true, completion: nil)
          result(nil)
      }
  }
}

// ViewController dedicado para exibir a WebView
class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL?
    var headers: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        setupNavigationBar()
    }

    private func setupWebView() {
        let webViewConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: webViewConfig)
        webView.navigationDelegate = self
        view.addSubview(webView)

        // Configurar as constraints para ocupar toda a tela
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        if let url = url {
            let request = NSMutableURLRequest(url: url)
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
            webView.load(request as URLRequest)
        }
    }

    private func setupNavigationBar() {
        title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Voltar",
            style: .plain,
            target: self,
            action: #selector(didTapBack)
        )
    }

    @objc private func didTapBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
