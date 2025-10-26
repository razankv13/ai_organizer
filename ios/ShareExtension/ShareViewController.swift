//
//  ShareViewController.swift
//  ShareExtension
//
//  iOS Share Extension for AI Organizer
//  Allows sharing URLs and text from Safari and other apps
//

import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    // App Group identifier - must match the one in main app and capabilities
    private let appGroupIdentifier = "group.com.example.ai_organizer"

    override func isContentValid() -> Bool {
        // Content is always valid for our simple use case
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post
        extractSharedData { [weak self] in
            // Close the extension
            self?.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    private func extractSharedData(completion: @escaping () -> Void) {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            completion()
            return
        }

        guard let itemProviders = extensionItem.attachments else {
            completion()
            return
        }

        // Get the user's comment/text from the share sheet
        let userText = contentText ?? ""

        // Process the first attachment
        if let itemProvider = itemProviders.first {
            processItemProvider(itemProvider, userText: userText, completion: completion)
        } else {
            completion()
        }
    }

    private func processItemProvider(_ itemProvider: NSItemProvider, userText: String, completion: @escaping () -> Void) {
        // Try URL first (for web pages)
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
                if let url = item as? URL {
                    self?.saveSharedData(url: url.absoluteString, title: userText)
                } else if let data = item as? Data,
                          let urlString = String(data: data, encoding: .utf8),
                          let url = URL(string: urlString) {
                    self?.saveSharedData(url: url.absoluteString, title: userText)
                }
                completion()
            }
        }
        // Try plain text
        else if itemProvider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (item, error) in
                if let text = item as? String {
                    // Check if text is a URL
                    if let url = URL(string: text), url.scheme != nil {
                        self?.saveSharedData(url: text, title: userText)
                    } else {
                        self?.saveSharedData(text: text, title: userText)
                    }
                }
                completion()
            }
        }
        // Try property list (some apps share as plist)
        else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
            itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil) { [weak self] (item, error) in
                if let dictionary = item as? [String: Any],
                   let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] {
                    // Safari shares data this way
                    if let urlString = results["URL"] as? String {
                        let title = results["title"] as? String ?? userText
                        self?.saveSharedData(url: urlString, title: title)
                    }
                }
                completion()
            }
        } else {
            completion()
        }
    }

    private func saveSharedData(url: String? = nil, text: String? = nil, title: String? = nil) {
        guard let userDefaults = UserDefaults(suiteName: appGroupIdentifier) else {
            return
        }

        // Save the shared content
        if let url = url {
            userDefaults.set(url, forKey: "sharedContent")
        } else if let text = text {
            userDefaults.set(text, forKey: "sharedContent")
        }

        // Save the title if provided
        if let title = title, !title.isEmpty {
            userDefaults.set(title, forKey: "sharedTitle")
        }

        // Synchronize to ensure data is saved
        userDefaults.synchronize()

        // Open the main app
        openMainApp()
    }

    private func openMainApp() {
        // Open the main app with a custom URL scheme
        guard let url = URL(string: "aiorganizer://share") else {
            return
        }

        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))

        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: url, afterDelay: 0)
                break
            }
            responder = responder?.next
        }
    }

    @objc private func openURL(_ url: URL) {
        // This method signature is required for the selector
    }
}
