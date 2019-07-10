//
//  PreLoginViewController.swift
//  OnePercentWin
//
//  Created by David_Lam on 6/7/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

class PreLoginViewController: BaseViewController {
    
    let viewModel = PreLoginViewModel()
    let spinner = SpinnerViewController()
    
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
        showSpinnerView()
        viewModel.loginWith(email: email, password: password)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        showSpinnerView()
        viewModel.createUserWith(email: email, password: password)
    }
    
    @IBAction func incongitoTapped(_ sender: Any) {
        showSpinnerView()
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

        styleEmailElements()
        stylePasswordElements()
    }
    
    fileprivate func stylePasswordElements() {
        passwordLabel.applyFont(fontSize: .medium)
        passwordTextField.applyFont(fontSize: .medium)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        passwordTextField.backgroundColor = .clear
    }
    
    fileprivate func styleEmailElements() {
        emailLabel.applyFont(fontSize: .medium)
        emailTextField.applyFont(fontSize: .medium)
        emailTextField.backgroundColor = .clear
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
    }
    
    private func setupViews() {
        if viewModel.hasUser {
            setupForLoggedInUser()
        } else {
            setupForLoggedOutUser()
        }
    }
    
    private func setupForLoggedInUser() {
        toggleButtons(isHidden: true)
        performSegue(withIdentifier: "presentMainViewController", sender: nil)
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
        hideSpinnerView()
        setupViews()
    }
    
    func signInFailed(message: String) {
        hideSpinnerView()
        setupViews()
        showAlertWithText(errorMessage: message)
    }
}

// MARK: - AuxillaryViews
extension PreLoginViewController {
    private func showSpinnerView() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func hideSpinnerView() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    private func showAlertWithText(errorMessage: String) {
        let alert = UIAlertController(title: "Oops something went wrong",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay",
                                       style: UIAlertAction.Style.destructive){ [weak self] _ in
            self?.dismiss(animated: true)
        }
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
    
}
