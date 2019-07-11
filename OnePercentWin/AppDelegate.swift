//
//  AppDelegate.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        setupFireStore()
        setupGoogleSignIn()
        setupUIAppearance()
        addNotificationCenterObserver()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(for: .applicationDidBecomeActive)
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
            return GIDSignIn.sharedInstance()
                .handle(url,
                        sourceApplication: sourceApplication,
                        annotation: [:])
    }
    
    fileprivate func setupFireStore() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let db = Firestore.firestore()
        db.settings = settings
    }

    fileprivate func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func addNotificationCenterObserver() {
        NotificationCenter.default.observeOnMainQueue(for: .themeDidChange) { [weak self] _ in
            self?.setupUIAppearance()
        }
    }
    
    func setupUIAppearance() {
        UITabBar.appearance().tintColor = ThemeHelper.defaultOrange()
        UITabBar.appearance().barTintColor = ThemeHelper.tabbarColor()
        UINavigationBar.appearance().barTintColor = ThemeHelper.backgroundColor()
    }
    
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        UserService().signInWithGoogleAuth(auth: credential, completion: { _ in })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
