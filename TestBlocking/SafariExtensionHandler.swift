//
//  SafariExtensionHandler.swift
//  AdvancedBlocking
//
//  Created by Dimitry Kolyshev on 30.01.2019.
//  Copyright © 2020 AdGuard Software Ltd. All rights reserved.
//

import SafariServices
import Foundation

class SafariExtensionHandler: SFSafariExtensionHandler {

    private var contentBlockerController: ContentBlockerController? = nil;

    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").

        if (self.contentBlockerController == nil) {
            self.contentBlockerController = ContentBlockerController.shared;
        }
        
        NSLog("AG: The extension received a message (%@)", messageName);
        
        // Content script requests scripts and css for current page
        if (messageName == "getAdvancedBlockingData") {
            do {
                if (userInfo == nil || userInfo!["url"] == nil) {
                    NSLog("AG: Empty url passed with the message");
                    return;
                }

                let url = userInfo?["url"] as? String ?? "";
                NSLog("AG: Page url: %@", url);

                let pageUrl = URL(string: url);
                if pageUrl == nil {
                    return;
                }
                
                let data: [String : Any]? = [
                    "data": try self.contentBlockerController!.getData(url: pageUrl!),
                    "verbose": self.isVerboseLoggingEnabled()
                ];
                page.dispatchMessageToScript(withName: "advancedBlockingData", userInfo: data);
            } catch {
                NSLog("AG: Error handling message (\(messageName)): \(error)");
            }
        }
    }

    // Returns true if verbose logging setting is enabled
    private func isVerboseLoggingEnabled() -> Bool {
        return true;
    }
    
    override func beginRequest(with context: NSExtensionContext) {
        
        let documentFolder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.AdgSimple")

        guard let jsonURL = documentFolder?.appendingPathComponent(Constants.blockerListFilename) else {
                    return
                }
        
        let attachment = NSItemProvider(contentsOf: jsonURL)!
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
