//
//  ContentBlockerController.swift
//  AdvancedBlocking
//
//  Created by Dimitry Kolyshev on 30.01.2019.
//  Copyright © 2020 AdGuard Software Ltd. All rights reserved.
//

import Foundation
import ContentBlockerConverter

class ContentBlockerController {

    // Singleton instance
    static let shared = ContentBlockerController();

    private var contentBlockerContainer: ContentBlockerContainer;
    private var blockerDataCache: NSCache<NSString, NSString>;

    // Constructor
    private init() {

        NSLog("AG: AdvancedBlocking init ContentBlockerController");

        contentBlockerContainer = ContentBlockerContainer();
        blockerDataCache = NSCache<NSString, NSString>();

        setupJson();
    }
    
    /**
     * Reads rules from test filter
     */
    func getRules() -> [String]? {
        let filePath = Bundle.main.url(forResource: "custom-filter", withExtension: "txt")
        do {
            let rules = try String(contentsOf: filePath!, encoding: .utf8)
            let result = rules.components(separatedBy: "\n")
            NSLog("\(result)")
            return result
        }
        catch {
            NSLog("Error reading test filter")
        }
        return nil
    }

    func initJson() throws {
//        let text = try String(contentsOfFile: AESharedResources.advancedBlockingContentRulesUrlString()!, encoding: .utf8);
        let rulesList = getRules()!;
        let conversionResult = ConverterService.convertRules(rules: rulesList)!
        if (conversionResult.advancedBlocking != nil) {
//            let rulesData = conversionResult.advancedBlocking!.data(using: .utf8)
            try self.contentBlockerContainer.setJson(json: conversionResult.advancedBlocking!);
        }
    }

    // Downloads and sets up json from shared resources
    func setupJson() {
        // Drop cache
        blockerDataCache = NSCache<NSString, NSString>();

        do {
            try initJson();
            NSLog("AG: AdvancedBlocking: Json setup successfully.");
        } catch {
            NSLog("AG: AdvancedBlocking: Error setting json: \(error)");
        }
    }

    func getBlockerData(url: URL) throws -> String {
        let data: BlockerData = try contentBlockerContainer.getData(url: url) as! BlockerData;

        let encoder = JSONEncoder();
        encoder.outputFormatting = .prettyPrinted

        let json = try encoder.encode(data);
        return String(data: json, encoding: .utf8)!;
    }

    // Returns requested scripts and css for specified url
    func getData(url: URL) throws -> String {
        let cacheKey = url.absoluteString as NSString;
        if let cachedVersion = blockerDataCache.object(forKey: cacheKey) {
            NSLog("AG: AdvancedBlocking: Return cached version");
            return cachedVersion as String;
        }

        var data = "";
        do {
            data = try getBlockerData(url: url);
            blockerDataCache.setObject(data as NSString, forKey: cacheKey);

            NSLog("AG: AdvancedBlocking: Return data");
        } catch {
            NSLog("AG: AdvancedBlocking: Error getting data: \(error)");
        }

        return data;
    }
}
