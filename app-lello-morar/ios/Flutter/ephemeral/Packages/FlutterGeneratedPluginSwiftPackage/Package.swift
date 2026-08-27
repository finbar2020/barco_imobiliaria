// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "adjust_sdk", path: "../.packages/adjust_sdk-5.7.1"),
        .package(name: "airplane_mode_checker", path: "../.packages/airplane_mode_checker-3.3.0"),
        .package(name: "camera_avfoundation", path: "../.packages/camera_avfoundation-0.10.2"),
        .package(name: "cloud_firestore", path: "../.packages/cloud_firestore-6.8.0"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-7.3.1"),
        .package(name: "datadog_flutter_plugin", path: "../.packages/datadog_flutter_plugin-3.5.0"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus-12.4.0"),
        .package(name: "file_picker", path: "../.packages/file_picker-10.3.10"),
        .package(name: "firebase_analytics", path: "../.packages/firebase_analytics-12.4.6"),
        .package(name: "firebase_app_installations", path: "../.packages/firebase_app_installations-0.4.2+7"),
        .package(name: "firebase_auth", path: "../.packages/firebase_auth-6.5.7"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.13.0"),
        .package(name: "firebase_crashlytics", path: "../.packages/firebase_crashlytics-5.2.7"),
        .package(name: "firebase_in_app_messaging", path: "../.packages/firebase_in_app_messaging-0.9.2+7"),
        .package(name: "firebase_messaging", path: "../.packages/firebase_messaging-16.5.0"),
        .package(name: "firebase_performance", path: "../.packages/firebase_performance-0.11.4+6"),
        .package(name: "firebase_remote_config", path: "../.packages/firebase_remote_config-6.5.6"),
        .package(name: "firebase_storage", path: "../.packages/firebase_storage-13.4.6"),
        .package(name: "flutter_contacts", path: "../.packages/flutter_contacts-2.3.1"),
        .package(name: "flutter_image_compress_common", path: "../.packages/flutter_image_compress_common-1.1.1"),
        .package(name: "flutter_local_notifications", path: "../.packages/flutter_local_notifications-22.3.0"),
        .package(name: "flutter_pdfview", path: "../.packages/flutter_pdfview-1.4.5"),
        .package(name: "fluttertoast", path: "../.packages/fluttertoast-10.0.0"),
        .package(name: "geolocator_apple", path: "../.packages/geolocator_apple-2.3.14"),
        .package(name: "image_cropper", path: "../.packages/image_cropper-12.2.1"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios-0.8.13+6"),
        .package(name: "in_app_review", path: "../.packages/in_app_review-2.0.12"),
        .package(name: "local_auth_darwin", path: "../.packages/local_auth_darwin-2.0.3"),
        .package(name: "open_file_ios", path: "../.packages/open_file_ios-1.1.0"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-9.0.1"),
        .package(name: "pdfium_flutter", path: "../.packages/pdfium_flutter-0.2.3"),
        .package(name: "permission_handler_apple", path: "../.packages/permission_handler_apple-9.6.1"),
        .package(name: "pointer_interceptor_ios", path: "../.packages/pointer_interceptor_ios-0.10.1+1"),
        .package(name: "share_plus", path: "../.packages/share_plus-12.0.2"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.3+1"),
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "wakelock_plus", path: "../.packages/wakelock_plus-1.5.2"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.26.0"),
        .package(name: "workmanager_apple", path: "../.packages/workmanager_apple-0.9.10"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "adjust-sdk", package: "adjust_sdk"),
                .product(name: "airplane-mode-checker", package: "airplane_mode_checker"),
                .product(name: "camera-avfoundation", package: "camera_avfoundation"),
                .product(name: "cloud-firestore", package: "cloud_firestore"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "datadog-flutter-plugin", package: "datadog_flutter_plugin"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "firebase-analytics", package: "firebase_analytics"),
                .product(name: "firebase-app-installations", package: "firebase_app_installations"),
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-crashlytics", package: "firebase_crashlytics"),
                .product(name: "firebase-in-app-messaging", package: "firebase_in_app_messaging"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "firebase-performance", package: "firebase_performance"),
                .product(name: "firebase-remote-config", package: "firebase_remote_config"),
                .product(name: "firebase-storage", package: "firebase_storage"),
                .product(name: "flutter-contacts", package: "flutter_contacts"),
                .product(name: "flutter-image-compress-common", package: "flutter_image_compress_common"),
                .product(name: "flutter-local-notifications", package: "flutter_local_notifications"),
                .product(name: "flutter-pdfview", package: "flutter_pdfview"),
                .product(name: "fluttertoast", package: "fluttertoast"),
                .product(name: "geolocator-apple", package: "geolocator_apple"),
                .product(name: "image-cropper", package: "image_cropper"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "in-app-review", package: "in_app_review"),
                .product(name: "local-auth-darwin", package: "local_auth_darwin"),
                .product(name: "open-file-ios", package: "open_file_ios"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "pdfium-flutter", package: "pdfium_flutter"),
                .product(name: "permission-handler-apple", package: "permission_handler_apple"),
                .product(name: "pointer-interceptor-ios", package: "pointer_interceptor_ios"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "wakelock-plus", package: "wakelock_plus"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "workmanager-apple", package: "workmanager_apple"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
