//
//  AppLauncherViewController.swift
//  OnePercentWin
//
//  Created by David on 31/3/20.
//  Copyright © 2020 David Lam. All rights reserved.
//

import UIKit

class AppLauncherViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = FirebaseFeatureManager()
        manager.setup()
        manager.fetchLatestConfig { latestConfig in
            if let latestConfig = latestConfig {
                FeatureConfiguration.shared.saveAndUpdateFeatures(features: latestConfig)
            }
            self.performSegue(withIdentifier: "presentPreLoginViewController", sender: nil)
        }
    }
}
