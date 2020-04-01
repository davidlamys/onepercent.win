//
//  PreLoginViewModel.swift
//  OnePercentWin
//
//  Created by David_Lam on 6/7/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol PreLoginViewModelDelegate: class {
    func signInCompleted()
    func signInFailed(message: String)
}

class PreLoginViewModel {
    private let userService = UserService()
    private let featureFlag: FeatureConfigurationType
    weak var delegate: PreLoginViewModelDelegate?
    
    init(featureFlag: FeatureConfigurationType = FeatureConfiguration.shared) {
        self.featureFlag = featureFlag
    }
    
    var hasUser: Bool {
        return userService.hasLoggedInUser()
    }
    
    func isGoogleSignInEnabled() -> Bool {
        return featureFlag.isFeatureEnabled(feature: .googleSignIn)
    }
    
    func signInAnonymously() {
        userService.signInAnonymously(completion: authenticationHandler) 
    }
    
    func loginWith(email: String, password: String) {
        userService.loginWith(email: email, password: password, completion: authenticationHandler)
    }
    
    func signWithGoogleAuth(auth: AuthCredential) {
        userService.signInWithGoogleAuth(auth: auth,
                                         completion: authenticationHandler)
    }
    
    func createUserWith(email: String, password: String) {
        userService.signUpWith(email: email, password: password, completion: authenticationHandler)
    }
    
    private func authenticationHandler(result: UserServiceResult) {
        switch result {
        case .success(let user):
            if let displayName = user.displayName {
                UserDefaultsWrapper.init().save(userName: displayName)
            }
            self.delegate?.signInCompleted()
        case .failure(let error):
            self.delegate?.signInFailed(message: error.localizedDescription)
        }
    }
}
