//
//  ContentBlockerService.swift
//  AdgSimple
//
//  Created by tvinzz on 15.05.2021.
//

import Foundation
import ContentBlockerConverter

class ConverterService {
    /**
     * Reads rules from test filter
     */
    static func getRules() -> [String]? {
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

    /**
     * Converts rules
     */
    static func convertRules(rules: [String]) -> String? {
        let result: ConversionResult? = ContentBlockerConverter().convertArray(rules: rules)
        return result!.converted
    }
    
    /**
     * Writes conversion result into file in groups directory
     */
    static func saveConversionResult(rules: Data) {
        let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.AdgSimple")

        let fileURL = dir!.appendingPathComponent(Constants.blockerListFilename)
        
        NSLog("Path to the content blocker: \(fileURL.absoluteString)")
        do {
            try rules.write(to: fileURL)
        }
        catch {
            NSLog("Error saving conversion result")
        }
    }
    
    static func applyConverter() {
        let rulesList = getRules()!
        let rulesData = convertRules(rules: rulesList)!.data(using: .utf8)
        saveConversionResult(rules: rulesData!)
    }
}
