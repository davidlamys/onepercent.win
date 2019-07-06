//
//  PreLoginViewController.swift
//  OnePercentWin
//
//  Created by David_Lam on 6/7/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol PreLoginViewModelDelegate: class {
    func signInCompleted()
}

class PreLoginViewModel {
    private let userService = UserService()
    
    weak var delegate: PreLoginViewModelDelegate?
    
    var hasUser: Bool {
        return userService.hasLoggedInUser()
    }
    
    func signInAnonymously() {
        userService.signInAnonymously { result in
            switch result {
            case .success:
                self.delegate?.signInCompleted()
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func loginWith(email: String, password: String) {
        userService.signInWith(email: email, password: password) { result in
            switch result {
            case .success:
                self.delegate?.signInCompleted()
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
}

class PreLoginViewController: BaseViewController {
    
    let viewModel = PreLoginViewModel()
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var incognitoButton: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        viewModel.loginWith(email: email, password: password)
    }
    
    @IBAction func incongitoTapped(_ sender: Any) {
        viewModel.signInAnonymously()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.observeOnMainQueue(for: .userDidChange) { _ in
            self.setupViews()
        }
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }
    
    override func styleElements() {
        loginButton.applyStyle()
        signupButton.applyStyle()
        incognitoButton.applyStyle()

        emailLabel.applyFont(fontSize: .medium)
        emailTextField.applyFont(fontSize: .medium)
        emailTextField.backgroundColor = .clear
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])

        passwordLabel.applyFont(fontSize: .medium)
        passwordTextField.applyFont(fontSize: .medium)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        passwordTextField.backgroundColor = .clear
    }
    
    private func setupForLoggedInUser() {
        toggleButtons(isHidden: true)
        performSegue(withIdentifier: "presentMainViewController", sender: nil)
    }
    
    private func setupViews() {
        if viewModel.hasUser {
            setupForLoggedInUser()
        } else {
            setupForLoggedOutUser()
        }
    }
    
    private func setupForLoggedOutUser() {
        toggleButtons(isHidden: false)
        dismiss(animated: true)
    }
    
    private func toggleButtons(isHidden: Bool) {
        emailLabel.isHidden = isHidden
        emailTextField.isHidden = isHidden
        emailTextField.text = nil
        passwordLabel.isHidden = isHidden
        passwordTextField.isHidden = isHidden
        passwordTextField.text = nil
        loginButton.isHidden = isHidden
        signupButton.isHidden = isHidden
        incognitoButton.isHidden = isHidden
    }
}

extension PreLoginViewController: PreLoginViewModelDelegate {
    func signInCompleted() {
        self.setupViews()
    }
}
