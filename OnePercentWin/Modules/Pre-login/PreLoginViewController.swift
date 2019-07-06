//
//  PreLoginViewController.swift
//  OnePercentWin
//
//  Created by David_Lam on 6/7/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit
import Firebase

class PreLoginViewController: BaseViewController {
    
    private let userService = UserService()
    private var goalsListner: UserGoalQueryListener!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var incognitoButton: UIButton!
    
    @IBAction func incongitoTapped(_ sender: Any) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if let result = authResult {
                self.setupViews()
            } else if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.observeOnMainQueue(for: .userDidChange) { _ in
            self.setupViews()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }
    
    override func styleElements() {
        loginButton.applyStyle()
        signupButton.applyStyle()
        incognitoButton.applyStyle()
    }
    
    private func setupForLoggedInUser() {
        toggleButtons(isHidden: true)
        goalsListner = UserGoalQueryListener.shared
        let userId = userService.userId()
        goalsListner.set(userId: userId)
        goalsListner?.delegate = self
    }
    
    private func setupViews() {
        if userService.hasLoggedInUser() {
            setupForLoggedInUser()
        } else {
            setupForLoggedOutUser()
        }
    }
    
    private func setupForLoggedOutUser() {
        goalsListner?.delegate = nil
        toggleButtons(isHidden: false)
        dismiss(animated: true)
    }
    
    private func toggleButtons(isHidden: Bool) {
        loginButton.isHidden = isHidden
        signupButton.isHidden = isHidden
        incognitoButton.isHidden = isHidden
    }
}

extension PreLoginViewController: RepoWrapperDelegate {
    func refreshWith(goals: [DailyGoal]) {
        guard userService.hasLoggedInUser() else {
            fatalError()
        }
        performSegue(withIdentifier: "presentMainViewController", sender: nil)
    }
}
