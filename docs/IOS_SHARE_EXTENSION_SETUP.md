# iOS Share Extension Setup Guide

**Feature:** Web Clipping Phase 2 - iOS Share Extension
**Purpose:** Allow users to share URLs and text from Safari and other iOS apps directly to AI Organizer
**Date:** 2025-10-25

---

## 📋 Overview

This guide explains how to configure the iOS Share Extension in Xcode. The extension allows users to:
- Share web pages from Safari
- Share URLs from any app
- Share text content
- Quick-save articles and links to AI Organizer

---

## 🚀 Setup Steps

### Step 1: Create Share Extension Target in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the navigator
3. Click the **+** button at the bottom of the targets list
4. Select **iOS → Share Extension**
5. Configure the extension:
   - **Product Name:** `ShareExtension`
   - **Team:** Your development team
   - **Organization Identifier:** `com.example.ai-organizer`
   - **Language:** Swift
   - **Project:** Runner
   - **Embed in Application:** Runner

### Step 2: Configure App Groups

App Groups allow the share extension to communicate with the main app.

#### Main App Configuration:
1. Select **Runner** target
2. Go to **Signing & Capabilities**
3. Click **+ Capability**
4. Add **App Groups**
5. Click **+** to add a new group
6. Name it: `group.com.example.ai_organizer`
7. Enable the checkbox

#### Share Extension Configuration:
1. Select **ShareExtension** target
2. Go to **Signing & Capabilities**
3. Click **+ Capability**
4. Add **App Groups**
5. Select the same group: `group.com.example.ai_organizer`
6. Enable the checkbox

### Step 3: Replace Share Extension Files

The Xcode template creates default files. Replace them with our custom implementation:

1. **Delete** the auto-generated files:
   - `ShareViewController.swift` (in ShareExtension folder)
   - `Info.plist` (in ShareExtension folder)
   - `MainInterface.storyboard` (if exists)

2. **Copy** our custom files:
   - From: `ios/ShareExtension/ShareViewController.swift`
   - From: `ios/ShareExtension/Info.plist`
   - To: The ShareExtension target in Xcode

3. **Ensure** files are added to ShareExtension target:
   - Select each file in Xcode
   - Check **Target Membership** in right panel
   - Ensure **ShareExtension** is checked

### Step 4: Configure Custom URL Scheme

1. Select **Runner** target
2. Go to **Info** tab
3. Expand **URL Types**
4. Click **+** to add new URL type:
   - **Identifier:** `com.example.ai-organizer.share`
   - **URL Schemes:** `aiorganizer`
   - **Role:** Editor

### Step 5: Configure Bundle Identifiers

Ensure the bundle identifiers are correct:

1. **Runner** target:
   - Bundle Identifier: `com.example.ai-organizer`

2. **ShareExtension** target:
   - Bundle Identifier: `com.example.ai-organizer.ShareExtension`
   - (Must be a sub-identifier of the main app)

### Step 6: Update Info.plist (Main App)

Add URL scheme to handle opens from share extension:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>com.example.ai-organizer.share</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>aiorganizer</string>
        </array>
    </dict>
</array>
```

### Step 7: Build and Test

1. Select **Runner** scheme
2. Build the project (`Cmd + B`)
3. Run on iOS Simulator or Device (`Cmd + R`)
4. Test sharing:
   - Open Safari
   - Navigate to any website
   - Tap Share button
   - Look for "Save to AI Organizer" in share sheet
   - Share the page
   - Main app should open with the content

---

## 🎯 How It Works

### Data Flow

```
Safari/Other App
    ↓ (User taps Share)
Share Extension
    ↓ (Extract URL/text)
UserDefaults (App Group)
    ↓ (Save to shared container)
ShareViewController closes
    ↓ (Opens main app via URL scheme)
Main App Opens
    ↓ (AppDelegate checks for shared data)
ShareReceiverService
    ↓ (Reads from UserDefaults)
Flutter Method Channel
    ↓ (Sends to Dart)
ShareReceiverProvider
    ↓ (Processes shared data)
WebClipperActions
    ↓ (Creates note with web clip)
Note saved to database
```

### Key Components

1. **ShareViewController.swift**
   - Handles share sheet UI
   - Extracts URLs and text
   - Saves to App Group UserDefaults
   - Opens main app

2. **AppDelegate.swift**
   - Registers Method Channel
   - Checks for shared data on launch
   - Passes data to Flutter

3. **ShareReceiverService.dart**
   - Method Channel communication
   - Provides shared data stream
   - Manages shared data lifecycle

4. **App Group**
   - Shared storage between app and extension
   - Key: `group.com.example.ai_organizer`

---

## 🐛 Troubleshooting

### Extension Doesn't Appear in Share Sheet

**Problem:** Share extension not visible in iOS share menu

**Solutions:**
1. Verify both targets have the same App Group enabled
2. Check bundle identifier format: `com.example.ai-organizer.ShareExtension`
3. Ensure extension is embedded in main app
4. Rebuild the app completely (Clean Build Folder: `Cmd + Shift + K`)
5. Restart device/simulator

### Shared Data Not Received

**Problem:** Main app doesn't receive shared content

**Solutions:**
1. Verify App Group identifier matches exactly in both targets:
   - AppDelegate.swift: `group.com.example.ai_organizer`
   - ShareViewController.swift: `group.com.example.ai_organizer`
2. Check URL scheme is registered correctly
3. Add debug logging in `checkSharedData()` method
4. Verify UserDefaults.synchronize() is called

### Build Errors

**Problem:** Xcode build fails

**Solutions:**
1. Ensure Swift version is same for both targets
2. Check deployment target (iOS 12.0+)
3. Verify all files are added to correct target
4. Clean derived data: `Cmd + Shift + K` then rebuild

### Extension Crashes

**Problem:** Share extension crashes when opened

**Solutions:**
1. Check Info.plist format is correct
2. Ensure all required frameworks are linked
3. Add error handling in ShareViewController
4. Test with different share sources (Safari, Notes, etc.)

---

## 🔒 Permissions & Capabilities

### Required Capabilities:

1. **Main App (Runner)**
   - App Groups: `group.com.example.ai_organizer`
   - URL Types: `aiorganizer://`

2. **Share Extension (ShareExtension)**
   - App Groups: `group.com.example.ai_organizer`

### No Additional Permissions Required:
- Share extensions run in sandboxed environment
- No internet, location, or file access needed
- All data passed via App Group container

---

## 📱 Testing Checklist

- [ ] Extension appears in Safari share sheet
- [ ] Extension appears in other apps' share sheets
- [ ] Can share a URL from Safari
- [ ] Can share plain text from Notes
- [ ] Main app opens after sharing
- [ ] Shared content creates a new note
- [ ] Note has correct title and content
- [ ] Web preview/metadata is fetched
- [ ] Share extension dismisses properly
- [ ] Works on both simulator and device
- [ ] Works with app already running
- [ ] Works with app in background
- [ ] Works when app is not running

---

## 💡 Customization

### Change Extension Display Name

Edit `ShareExtension/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Save to AI Organizer</string>
```

### Change Activation Rules

Edit `Info.plist` → NSExtensionActivationRule to control what content types the extension accepts:

```xml
<key>NSExtensionActivationRule</key>
<dict>
    <!-- Accept web URLs -->
    <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
    <integer>1</integer>

    <!-- Accept web pages -->
    <key>NSExtensionActivationSupportsWebPageWithMaxCount</key>
    <integer>1</integer>

    <!-- Accept text -->
    <key>NSExtensionActivationSupportsText</key>
    <true/>

    <!-- Accept images (optional) -->
    <key>NSExtensionActivationSupportsImageWithMaxCount</key>
    <integer>0</integer>

    <!-- Accept files (optional) -->
    <key>NSExtensionActivationSupportsFileWithMaxCount</key>
    <integer>0</integer>
</dict>
```

### Add Custom UI

The ShareViewController extends SLComposeServiceViewController which provides a default UI. To customize:

1. Create a custom view controller
2. Update Info.plist to reference your storyboard
3. Handle UI interactions manually

---

## 🚀 Advanced Features

### JavaScript Preprocessing (Safari Only)

For advanced Safari integration, add a JavaScript file to extract more metadata:

1. Create `Preprocessor.js` in ShareExtension
2. Add to Info.plist:

```xml
<key>NSExtensionAttributes</key>
<dict>
    <key>NSExtensionJavaScriptPreprocessingFile</key>
    <string>Preprocessor</string>
    ...
</dict>
```

### Background Processing

Share extensions have limited execution time (~30 seconds). For long operations:

1. Save data to App Group
2. Close extension immediately
3. Main app processes in background
4. Use background fetch for heavy tasks

---

## 📚 References

- [Apple Share Extension Documentation](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html)
- [App Groups Documentation](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups)
- [Method Channel Flutter Documentation](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [SLComposeServiceViewController](https://developer.apple.com/documentation/social/slcomposeserviceviewcontroller)

---

## ✅ Verification

After setup, verify these files exist and are configured:

**Flutter/Dart:**
- ✅ `lib/services/share_receiver_service.dart`
- ✅ `lib/providers/share_receiver_provider.dart`

**iOS:**
- ✅ `ios/Runner/AppDelegate.swift` (updated with Method Channel)
- ✅ `ios/ShareExtension/ShareViewController.swift`
- ✅ `ios/ShareExtension/Info.plist`

**Android:**
- ✅ `android/app/src/main/java/com/example/ai_organizer/MainActivity.java`
- ✅ `android/app/src/main/AndroidManifest.xml` (with SEND intent filter)

**Configuration:**
- ✅ App Group: `group.com.example.ai_organizer`
- ✅ URL Scheme: `aiorganizer://share`
- ✅ Bundle IDs properly configured
- ✅ Signing configured for both targets

---

**Setup Time:** ~30-45 minutes (first time)
**Difficulty:** Intermediate
**Requirements:** Xcode 14+, iOS 12.0+, Paid Apple Developer Account (for App Groups)
