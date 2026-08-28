// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "cloud_firestore", path: "../.packages/cloud_firestore-6.8.0"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-7.3.1"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus-12.4.0"),
        .package(name: "file_picker", path: "../.packages/file_picker-10.3.10"),
        .package(name: "file_selector_macos", path: "../.packages/file_selector_macos-0.9.5"),
        .package(name: "firebase_analytics", path: "../.packages/firebase_analytics-12.4.6"),
        .package(name: "firebase_app_installations", path: "../.packages/firebase_app_installations-0.4.2+7"),
        .package(name: "firebase_auth", path: "../.packages/firebase_auth-6.5.7"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.13.0"),
        .package(name: "firebase_crashlytics", path: "../.packages/firebase_crashlytics-5.2.7"),
        .package(name: "firebase_messaging", path: "../.packages/firebase_messaging-16.5.0"),
        .package(name: "firebase_remote_config", path: "../.packages/firebase_remote_config-6.5.6"),
        .package(name: "firebase_storage", path: "../.packages/firebase_storage-13.4.6"),
        .package(name: "flutter_contacts", path: "../.packages/flutter_contacts-2.3.1"),
        .package(name: "flutter_image_compress_macos", path: "../.packages/flutter_image_compress_macos-1.1.0"),
        .package(name: "flutter_local_notifications", path: "../.packages/flutter_local_notifications-22.3.0"),
        .package(name: "geolocator_apple", path: "../.packages/geolocator_apple-2.3.14"),
        .package(name: "in_app_review", path: "../.packages/in_app_review-2.0.12"),
        .package(name: "local_auth_darwin", path: "../.packages/local_auth_darwin-2.0.3"),
        .package(name: "open_file_mac", path: "../.packages/open_file_mac-1.1.0"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-9.0.1"),
        .package(name: "pdfium_flutter", path: "../.packages/pdfium_flutter-0.2.3"),
        .package(name: "share_plus", path: "../.packages/share_plus-12.0.2"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.3+1"),
        .package(name: "url_launcher_macos", path: "../.packages/url_launcher_macos-3.2.5"),
        .package(name: "wakelock_plus", path: "../.packages/wakelock_plus-1.5.2"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.26.0"),
        .package(name: "workmanager_apple", path: "../.packages/workmanager_apple-0.9.10"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "cloud-firestore", package: "cloud_firestore"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "file-selector-macos", package: "file_selector_macos"),
                .product(name: "firebase-analytics", package: "firebase_analytics"),
                .product(name: "firebase-app-installations", package: "firebase_app_installations"),
                .product(name: "firebase-auth", package: "firebase_auth"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-crashlytics", package: "firebase_crashlytics"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "firebase-remote-config", package: "firebase_remote_config"),
                .product(name: "firebase-storage", package: "firebase_storage"),
                .product(name: "flutter-contacts", package: "flutter_contacts"),
                .product(name: "flutter-image-compress-macos", package: "flutter_image_compress_macos"),
                .product(name: "flutter-local-notifications", package: "flutter_local_notifications"),
                .product(name: "geolocator-apple", package: "geolocator_apple"),
                .product(name: "in-app-review", package: "in_app_review"),
                .product(name: "local-auth-darwin", package: "local_auth_darwin"),
                .product(name: "open-file-mac", package: "open_file_mac"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "pdfium-flutter", package: "pdfium_flutter"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "url-launcher-macos", package: "url_launcher_macos"),
                .product(name: "wakelock-plus", package: "wakelock_plus"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "workmanager-apple", package: "workmanager_apple"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
