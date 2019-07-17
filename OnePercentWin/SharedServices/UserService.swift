//
//  UserService.swift
//  OnePercentWin
//
//  Created by David on 25/12/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

typealias UserServiceResult = Result<OPWUser, Error>

struct OPWUser {
    let displayName: String?
}


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
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.default.post(for: .userDidChange)
            GIDSignIn.sharedInstance().signOut()
        } catch let error {
            print(error)
        }
    }
    
    func didAuthenticateUser() {
        NotificationCenter.default.post(for: .userDidChange)
    }
    
    func signInAnonymously(completion: @escaping (UserServiceResult) -> Void) {
        Auth.auth().signInAnonymously { (result, error) in
            if let error = error {
                completion(UserServiceResult.failure(error))
                return
            }
            if let result = result {
                self.didAuthenticateUser()
                completion(UserServiceResult.success(OPWUser(displayName: result.user.displayName)))
                return
            }
            fatalError()
        }
    }
    
    func loginWith(email: String,
                    password: String,
                    completion: @escaping (UserServiceResult) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(UserServiceResult.failure(error))
                return
            }
            if let result = result {
                self.didAuthenticateUser()
                completion(UserServiceResult.success(OPWUser(displayName: result.user.displayName)))
                return
            }
            fatalError()
        }
    }
    
    func signInWithGoogleAuth(auth: AuthCredential,
                              completion: @escaping (UserServiceResult) -> Void) {
        Auth.auth().signInAndRetrieveData(with: auth) { (result, error) in
            if let error = error {
                completion(UserServiceResult.failure(error))
                return
            }
            if let result = result {
                self.didAuthenticateUser()
                completion(UserServiceResult.success(OPWUser(displayName: result.user.displayName)))
                return
            }
            fatalError()
        }
    }
    
    func signUpWith(email: String,
                    password: String,
                    completion: @escaping (UserServiceResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(UserServiceResult.failure(error))
                return
            }
            if let result = result {
                self.didAuthenticateUser()
                completion(UserServiceResult.success(OPWUser(displayName: result.user.displayName)))
                return
            }
            fatalError()
        }
    }
    
    func updateDisplayName(to newName: String) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let newRequest = user.createProfileChangeRequest()
        newRequest.displayName = newName
        newRequest.commitChanges { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
}
