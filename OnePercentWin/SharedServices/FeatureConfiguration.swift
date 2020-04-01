//
//  FeatureConfiguration.swift
//  OnePercentWin
//
//  Created by David on 31/3/20.
//  Copyright © 2020 David Lam. All rights reserved.
//

import Foundation

// key where raw values must matches source
public enum Features: String, CaseIterable {
    case enableDarkMode = "enable_dark_mode"
    case googleSignIn = "enable_google_sigin"
    case welcomeMessage = "welcome_message"
}

public protocol FeatureConfigurationType {
    func isFeatureEnabled(feature: Features) -> Bool
    func saveAndUpdateFeatures(features: [Features: Any])
    func updateFeatures(userDefaults: UserDefaults)
    func getFeatures() -> [Features: Any]
    func saveFeatures(userDefaults: UserDefaults, features: [Features: Any])
    func getValue<T>(feature: Features) -> T?
    func getCollection(feature: Features) -> [String]
}

public class FeatureConfiguration: FeatureConfigurationType {

    public static let shared: FeatureConfigurationType = FeatureConfiguration()

    private init() {
        assert(self.featureConfig.count == Features.allCases.count)
    }

    public func getValue<T>(feature: Features) -> T? {
        return featureConfig[feature] as? T
    }

    public func getCollection(feature: Features) -> [String] {
        if let flag = featureConfig[feature] as? String {
            let splittedArray = flag.split(separator: ",")
            return splittedArray.map { String($0) }
        }
        print("feature flag not found for \(feature.rawValue)")
        return []
    }

    public func isFeatureEnabled(feature: Features) -> Bool {
        guard let enabled = featureConfig[feature] as? Bool else {
            print("Unable to find feature \(feature.rawValue) in feature config")
            return false
        }
        return enabled
    }

    // fall back default
    fileprivate var featureConfig: [Features: Any] = [
        .enableDarkMode: false,
        .googleSignIn: true,
        .welcomeMessage: "fall back string"
    ]

    public func getFeatures() -> [Features: Any] {
        return self.featureConfig
    }

    public func saveAndUpdateFeatures(features: [Features: Any]) {
        saveFeatures(features: features)
        updateFeatures()
    }

    private let featureFlagsKey = "featureFlags"

    public func updateFeatures(userDefaults: UserDefaults = UserDefaults.standard) {
        if let decoded  = userDefaults.data(forKey: featureFlagsKey),
            let localFeatureConfig = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [String: Any] {
            for key in self.featureConfig.keys {
                if let value = localFeatureConfig[key.rawValue] {
                    featureConfig[key] = value
                }
            }
        }
    }

    public func saveFeatures(userDefaults: UserDefaults = UserDefaults.standard,
                             features: [Features: Any]) {
        var featureConfig = [String: Any]()
        for (key, value) in features {
            featureConfig[key.rawValue] = value
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: featureConfig)
        userDefaults.set(encodedData, forKey: featureFlagsKey)
        userDefaults.synchronize()
    }

    required init(coder aDecoder: NSCoder) {
        featureConfig = aDecoder.decodeObject(forKey: featureFlagsKey) as? [Features: Any] ?? [:]
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(featureConfig, forKey: featureFlagsKey)
    }
}
