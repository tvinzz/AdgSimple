//
//  AdgSimpleApp.swift
//  AdgSimple
//
//  Created by tvinzz on 14.05.2021.
//

import SwiftUI
import ContentBlockerConverter
import SafariServices

@main
struct AdgSimpleApp: App {
    init() {
        ConverterService.applyConverter();
        // reload TestBlocking extension
        NSLog("Start reloading the content blocker")
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "dev.tvinzz.AdgSimple.TestBlocking", completionHandler: { _ in
            NSLog("Finished reloading the content blocker")
        })
        
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: "dev.tvinzz.AdgSimple.TestBlocking", completionHandler: { (state, error) in
            if let error = error {
                NSLog("Content blocker error: \(error)")
            }
            if let state = state {
                let contentBlockerIsEnabled = state.isEnabled
                NSLog("Content blocker state: \(contentBlockerIsEnabled ? "Enabled" : "Disabled")")
            }
        })
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

