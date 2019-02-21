//
//  UserDefaultsWrapper.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

struct UserDefaultsWrapper {
    let userDefaults = UserDefaults.standard
    
    func getTheme() -> ThemeType {
        guard let settings = self.getSettings() else {
            return .dark
        }
        guard let theme =  settings.theme else {
            return .dark
        }
        return theme
    }
    
    func save(theme: ThemeType) {
        guard var settings = self.getSettings() else {
            fatalError()
        }
        settings.theme = theme
        self.save(settings: settings)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: "userId")
    }
    
    func save(userId: String = UUID.init().uuidString) {
        UserDefaults.standard.setValue(userId, forKey: "userId")
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: "user")
    }
    
    func save(userName: String) {
        UserDefaults.standard.setValue(userName, forKey: "user")
    }
    
    func save(settings: UserSettings?) {
        guard settings != nil else {
            removeSettings()
            return
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(settings), forKey:"userSettings")

    }
    
    func removeSettings() {
        UserDefaults.standard.set(nil, forKey: "userSettings")
    }
    
    func getSettings() -> UserSettings? {
        guard let data = UserDefaults.standard.value(forKey: "userSettings") as? Data else {
            return nil
        }
        
        do {
            let settings = try PropertyListDecoder().decode(UserSettings.self, from: data)
            return settings
        } catch let err {
            print(err)
            return nil
        }
    }
}
