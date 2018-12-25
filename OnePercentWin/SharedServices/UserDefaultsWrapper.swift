//
//  UserDefaultsWrapper.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

struct UserDefaultsWrapper {
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
