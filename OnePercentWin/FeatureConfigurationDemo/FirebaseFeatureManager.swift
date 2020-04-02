//
//  FirebaseFeatureManager.swift
//  OnePercentWin
//
//  Created by David on 31/3/20.
//  Copyright © 2020 David Lam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

protocol FirebaseFeatureManagerType {
}

class FirebaseFeatureManager: FirebaseFeatureManagerType {
    var remoteConfig: FirebaseRemoteConfig
    var featureConfiguration: FeatureConfigurationType

    init(remoteConfig: FirebaseRemoteConfig = RemoteConfig.remoteConfig(),
         featureConfiguration: FeatureConfigurationType = FeatureConfiguration.shared) {
        self.featureConfiguration = featureConfiguration
        self.remoteConfig = remoteConfig
    }

    func setup() -> Bool {
        let fileName = "GoogleService-Info"
        guard
            let filePath = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let firebaseOptions = FirebaseOptions(contentsOfFile: filePath)
            else {
                return false
        }

        if FirebaseApp.app() == nil {
            FirebaseApp.configure(options: firebaseOptions)
        }

        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings(developerModeEnabled: true)
        
//        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        

        return true
    }

    func updateFeatureConfig() -> [Features: Any] {
        var updatedConfig = [Features: Any]()
        let featureConfig = self.featureConfiguration.getFeatures()

        for key in featureConfig.keys {
            let remoteValue = self.remoteConfig.configValue(forKey: key.rawValue)

            if let newValue = key.parseFrom(remoteConfig: remoteValue) {
                updatedConfig[key] = newValue
            }
        }
        return updatedConfig
    }

    func fetchLatestConfig(completion: @escaping (([Features: Any]?) -> Void)) {
        self.remoteConfig.fetch(withExpirationDuration: 0) { (status, _) in
            if status == .success {
                _ = self.remoteConfig.activateFetched()
                completion(self.updateFeatureConfig())
            }
            if status == .failure {
                completion(nil)
            }
        }
    }
}

enum FirebaseFeatureManagerError: Error {
    case fetchConfigFailed
}

protocol FirebaseRemoteConfig {
    var configSettings: RemoteConfigSettings { get set }
    func setDefaults(_ defaults: [String: NSObject]?)
    func configValue(forKey key: String?) -> RemoteConfigValue
    func fetch(withExpirationDuration expirationDuration: TimeInterval, completionHandler: RemoteConfigFetchCompletion?)
    func activateFetched() -> Bool
    func allKeys(from source: RemoteConfigSource, namespace aNamespace: String?) -> [String]
    func keys(withPrefix prefix: String?) -> Set<String>
}

extension RemoteConfig: FirebaseRemoteConfig {
}

extension Features {
    func parseFrom(remoteConfig: RemoteConfigValue) -> Any? {
        switch self {
        case .welcomeMessage:
            return remoteConfig.stringValue
        default:
            return remoteConfig.boolValue
        }
    }
}
