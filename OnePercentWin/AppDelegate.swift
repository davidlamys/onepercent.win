//
//  AppDelegate.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let db = Firestore.firestore()
        db.settings = settings
        setupUIAppearance()
        addNotificationCenterObserver()
        return true
    }
    
    func addNotificationCenterObserver() {
        NotificationCenter.default.observeOnMainQueue(for: .themeDidChange) { _ in
            self.setupUIAppearance()
        }
    }
    
    func setupUIAppearance() {
        UITabBar.appearance().tintColor = ThemeHelper.defaultOrange()
        UITabBar.appearance().barTintColor = ThemeHelper.tabbarColor()
        UINavigationBar.appearance().barTintColor = ThemeHelper.backgroundColor()
    }
    
}
