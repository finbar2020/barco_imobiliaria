# iOS & Android Flutter Flavors Setup Guide

## 📱 Flutter Flavor Standard

This project follows the **official Flutter flavors approach** as documented in:
- [Flutter iOS Flavors Documentation](https://docs.flutter.dev/deployment/flavors-ios)
- [Flutter Android Flavors Documentation](https://docs.flutter.dev/deployment/flavors)

### Key Principles

1. **Use standard Build Configurations**: `Debug`, `Release`, `Profile`
2. **Use Schemes (iOS) and Product Flavors (Android)** to differentiate flavors
3. **Use `--flavor` flag** in Flutter build commands
4. **Avoid custom Build Configurations** per flavor (not recommended by Flutter)

## 🏗️ Architecture

### iOS Structure
```
Build Configurations: Debug, Release, Profile (standard)
Schemes:
  - staging (Lello homolog)     → Profile configuration
  - prod (Lello production)     → Release configuration
  - hubert_homolog              → Profile configuration
  - hubert (Hubert production)  → Release configuration
```

### Android Structure
```gradle
flavorDimensions "env"
productFlavors {
    lello { ... }
    hubert { ... }
}
```

## 🔧 Build Commands

### Local Development

**iOS:**
```bash
# Lello
flutter build ios --flavor lello --release --target=lib/main-prod.dart
flutter build ios --flavor lello --release --target=lib/main-staging.dart

# Hubert
flutter build ios --flavor hubert --release --target=lib/main-prod.dart
flutter build ios --flavor hubert --release --target=lib/main-staging.dart
```

**Android:**
```bash
# Lello
flutter build apk --flavor lello --release -t lib/main-staging.dart
flutter build appbundle --flavor lello --release -t lib/main-prod.dart

# Hubert
flutter build apk --flavor hubert --release -t lib/main-staging.dart
flutter build appbundle --flavor hubert --release -t lib/main-prod.dart
```

## 🚀 Fastlane Deployment

## 🚀 Fastlane Deployment

### Firebase Distribution (Homolog)
```bash
cd ios
bundle exec fastlane firebase flavor:lello environment:homolog

cd android
bundle exec fastlane firebase flavor:hubert environment:homolog
```

### TestFlight / Play Store (Production)
```bash
cd ios
bundle exec fastlane testflight_beta flavor:lello environment:prod

cd android
bundle exec fastlane upload_google_play_store_internal flavor:hubert environment:prod
```

## 🔐 Environment Variables Required for CI/CD

### iOS TestFlight API Keys

Configure the following environment variables in your GitLab CI/CD settings to enable App Store Connect API authentication for TestFlight uploads:

### Lello App

```bash
IOS_APP_STORE_APIKEY_ID_LELLO=<your-key-id>
IOS_APP_STORE_APIKEY_ISSUER_LELLO=<your-issuer-id>
IOS_APP_STORE_APIKEY_FILE_LELLO=<path-to-key-file>
```

### Hubert App

```bash
IOS_APP_STORE_APIKEY_ID_HUBERT=<your-key-id>
IOS_APP_STORE_APIKEY_ISSUER_HUBERT=<your-issuer-id>
IOS_APP_STORE_APIKEY_FILE_HUBERT=<path-to-key-file>
```

## Fallback: Manual Authentication

If API keys are not configured, the Fastfile will fallback to manual authentication requiring:

```bash
FASTLANE_USERNAME=victor.mariano@lello.com.br
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=<app-specific-password>
```

Note: For Hubert, use a separate App-Specific Password:
```bash
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD_HUBERT=<hubert-app-specific-password>
```

## How to Generate App Store Connect API Keys

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access** > **Keys** (under Integrations)
3. Click **Generate API Key** or **+**
4. Set a name (e.g., "CI/CD Fastlane - Morar Viver")
5. Select **Access**: App Manager or Developer
6. Download the `.p8` file (only available once!)
7. Note the **Key ID** and **Issuer ID**

## Setting Up in GitLab CI/CD

1. Go to your GitLab project > **Settings** > **CI/CD** > **Variables**
2. Add the following variables (mark as **Protected** and **Masked** where applicable):
   - `IOS_APP_STORE_APIKEY_ID_LELLO` → Key ID from App Store Connect
   - `IOS_APP_STORE_APIKEY_ISSUER_LELLO` → Issuer ID from App Store Connect
   - `IOS_APP_STORE_APIKEY_FILE_LELLO` → Upload the `.p8` file as a **File** variable
   - Repeat for `*_HUBERT` variants

## Local Development

For local TestFlight uploads without API keys, run:

```bash
cd ios
FASTLANE_USERNAME="your-email@lello.com.br" \
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="your-app-specific-password" \
bundle exec fastlane testflight_beta flavor:lello environment:prod
```

To generate an App-Specific Password:
1. Visit [Apple ID Account](https://appleid.apple.com/account/manage)
2. Sign in with your Apple ID
3. Navigate to **Security** > **App-Specific Passwords**
4. Generate a new password for "Fastlane CLI"

## Ruby Automation Scripts

Two Ruby scripts are provided to configure the iOS project following Flutter standards:

### 1. `configure_schemes.rb`

Configures the Xcode project to use **standard Build Configurations** (Debug, Release, Profile) with Schemes for flavor differentiation:

```bash
cd ios
bundle exec ruby configure_schemes.rb
```

This script:
- Ensures only standard Build Configurations exist (Debug, Release, Profile)
- Removes custom per-flavor configurations (e.g., "Debug Hubert")
- Configures code signing to use Match profiles
- Schemes control which Bundle ID and Team ID to use

### 2. `configure_xcconfig.rb`

Links Flutter's standard xcconfig files to Build Configurations:

```bash
cd ios
bundle exec ruby configure_xcconfig.rb
```

This script:
- Links `Flutter/Debug.xcconfig` to Debug configuration
- Links `Flutter/Profile.xcconfig` to Profile configuration
- Links `Flutter/Release.xcconfig` to Release configuration
- No flavor-specific xcconfig files needed (Flutter handles this via --flavor)

**Note:** Run both scripts after cloning or when setting up a new machine.

## 📂 Project Structure

## 📂 Project Structure

### iOS
```
ios/
├── config/
│   ├── lello/
│   │   ├── GoogleService-Info.plist
│   │   └── Info.plist
│   └── hubert/
│       ├── GoogleService-Info.plist
│       └── Info.plist
├── configure_schemes.rb          # Configures Schemes for flavors
├── configure_xcconfig.rb          # Links xcconfig files
└── fastlane/
    └── Fastfile                   # Uses --flavor flag
```

### Android
```
android/
├── app/
│   ├── build.gradle              # Product flavors defined here
│   └── src/
│       ├── lello/                # Lello-specific resources
│       └── hubert/               # Hubert-specific resources
└── fastlane/
    └── Fastfile                  # Uses --flavor flag
```

## 🎯 How Flutter --flavor Works

When you run `flutter build ios --flavor hubert`:

1. **Flutter** looks for a Scheme named `hubert` (or similar)
2. The **Scheme** points to a Build Configuration (Debug/Release/Profile)
3. The **Scheme** also defines:
   - Which Bundle ID to use (`app.hubert.morador`)
   - Which Team ID to use (`Z3H6XQP5FK`)
   - Which provisioning profile to use
4. **Fastlane** copies the correct config files before building
5. **gym** uses the Scheme name to build the correct flavor

This is simpler and more maintainable than creating duplicate Build Configurations.

## ⚠️ Common Issues & Solutions

### Issue: "No provisioning profile found"
**Solution:** Ensure Schemes are configured with correct Bundle IDs and run:
```bash
cd ios
bundle exec fastlane match adhoc
bundle exec fastlane match appstore
```

### Issue: "Build Configuration not found"
**Solution:** The project should only have Debug, Release, Profile. If you see custom configs like "ReleaseHubert", remove them and re-run `configure_schemes.rb`.

### Issue: Flutter build uses wrong Bundle ID
**Solution:** Check that:
1. Scheme settings have correct Bundle ID
2. `Info.plist` in `config/{flavor}/` folder has correct values
3. Fastfile copies the correct config files before building

## 🔄 Migration Notes

This project was refactored from using custom Build Configurations per flavor to using the **Flutter standard approach** with Schemes. Benefits:

✅ Simpler project structure  
✅ Follows official Flutter documentation  
✅ Easier to maintain and debug  
✅ Works seamlessly with `flutter build --flavor`  
✅ No need for flavor-specific xcconfig files  

## 📚 Additional Resources

- [Flutter iOS Deployment Guide](https://docs.flutter.dev/deployment/ios)
- [Fastlane Match Documentation](https://docs.fastlane.tools/actions/match/)
- [Xcode Schemes and Configurations](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project)

## 🆘 Support

For issues or questions:
1. Check the official Flutter flavors documentation
2. Verify Scheme configuration in Xcode
3. Review Fastfile logs for build details
4. Contact the development team

---

**Last Updated:** January 31, 2026  
**Flutter Standard:** ✅ Compliant
