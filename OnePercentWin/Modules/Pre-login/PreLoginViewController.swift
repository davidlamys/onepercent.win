//
//  PreLoginViewController.swift
//  OnePercentWin
//
//  Created by David_Lam on 6/7/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class PreLoginViewController: BaseViewController {
    
    let viewModel = PreLoginViewModel()
    let spinner = SpinnerViewController()
    
    @IBOutlet weak var incognitoButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBAction func incongitoTapped(_ sender: Any) {
        showSpinnerView()
        viewModel.signInAnonymously()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.observeOnMainQueue(for: .userDidChange) { _ in
            self.setupViews()
        }
        
        NotificationCenter.default.observeOnMainQueue(for: .themeDidChange) { _ in
            self.styleElements()
        }
        
        viewModel.delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }
    
    override func styleElements() {
        incognitoButton.applyStyle()
        
        let theme = ThemeHelper.getTheme()
        switch theme {
        case .light:
            googleSignInButton.colorScheme = .dark
        case .dark:
            googleSignInButton.colorScheme = .light
        }
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
        incognitoButton.isHidden = isHidden
        
        if viewModel.isGoogleSignInEnabled() {
            googleSignInButton.isHidden = isHidden
        } else {
            googleSignInButton.isHidden = true
        }
    }
    
}

extension PreLoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            showAlertWithText(errorMessage: error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        showSpinnerView()
        viewModel.signWithGoogleAuth(auth: credential)
    }
}

extension PreLoginViewController: PreLoginViewModelDelegate {
    func signInCompleted() {
        precondition(Thread.isMainThread)
        hideSpinnerView()
    }
    
    func signInFailed(message: String) {
        precondition(Thread.isMainThread)
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
