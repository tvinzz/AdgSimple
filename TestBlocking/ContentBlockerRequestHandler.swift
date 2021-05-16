//
//  ContentBlockerRequestHandler.swift
//  TestBlocking
//
//  Created by tvinzz on 14.05.2021.
//

import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        
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
