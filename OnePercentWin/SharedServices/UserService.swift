//
//  UserService.swift
//  OnePercentWin
//
//  Created by David on 25/12/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserService {
    
    private let userDefaultsWrapper = UserDefaultsWrapper()
    
    func hasLoggedInUser() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func hasUser() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        
        if userDefaultsWrapper.getUserName() != nil {
            return true
        }
        
        return false
    }
    
    func userId() -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        
        if let tempUserId = userDefaultsWrapper.getUserId() {
            return tempUserId
        }
        
        let newUserId = UUID.init().uuidString
        userDefaultsWrapper.save(userId: newUserId)
        return newUserId
    }
    
}
