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
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: "dev.tvinzz.AdgSimple.TestBlocking", completionHandler: { _ in })
        
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: "dev.tvinzz.AdgSimple.TestBlocking", completionHandler: { (state, error) in
            if let error = error {
                print("Content blocker error: \(error)")
            }
            if let state = state {
                let contentBlockerIsEnabled = state.isEnabled
                print("Content blocker state: \(contentBlockerIsEnabled ? "Enabled" : "Disabled")")
            }
        })
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

