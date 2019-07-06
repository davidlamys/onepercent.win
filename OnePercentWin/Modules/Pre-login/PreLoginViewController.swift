//
//  PreLoginViewController.swift
//  OnePercentWin
//
//  Created by David_Lam on 6/7/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

class PreLoginViewController: BaseViewController {

    private let userService = UserService()
    private var goalsListner: UserGoalQueryListener!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var incognitoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if userService.hasLoggedInUser() {
            toggleButtons(isHidden: true)
            goalsListner = UserGoalQueryListener.shared
            let userId = userService.userId()
            goalsListner.set(userId: userId)
            goalsListner?.delegate = self
        } else {
            goalsListner?.delegate = nil
            toggleButtons(isHidden: false)
        }
    }
    
    override func styleElements() {
        loginButton.applyStyle()
        signupButton.applyStyle()
        incognitoButton.applyStyle()
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
