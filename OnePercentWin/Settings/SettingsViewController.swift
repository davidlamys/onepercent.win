//
//  SettingsViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseUI
import FirebaseAuth

fileprivate let disabledAlpha: CGFloat = 0.5

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var themeLabel: UILabel!
    @IBOutlet weak private var morningReminderLabel: UILabel!
    @IBOutlet weak private var eveningReminderLabel: UILabel!
    
    @IBOutlet weak private var themeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak private var morningReminderSwitch: UISwitch!
    @IBOutlet weak private var eveningReminderSwitch: UISwitch!
    @IBOutlet weak private var morningReminderTimePicker: UIDatePicker!
    @IBOutlet weak private var eveningReminderTimePicker: UIDatePicker!
    
    @IBOutlet weak private var signInButton: UIButton!
    @IBOutlet weak private var getNosy: UIButton!
    
    @IBOutlet weak private var userNameTextField: UITextField!
    
    fileprivate func displayAuthenticationUI() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true)
    }
    
    @IBAction func didTapSignIn(_ sender: Any) {
        if viewModel.hasLoggedInUser {
            viewModel.signOutUser()
            setupAuthenticationButton()
        } else {
            displayAuthenticationUI()
        }
    }
    
    @IBAction func nameTextField(_ sender: Any) {
        if let textField = sender as? UITextField,
            let userName = textField.text {
            viewModel.save(userName: userName)
        }
    }
    
    @IBAction func morningReminderToggled(_ sender: Any) {
        let shouldHide = !morningReminderSwitch.isOn
        self.morningReminderTimePicker.isEnabled = !shouldHide
        UIView.animate(withDuration: 0.5) {
            self.morningReminderTimePicker.alpha = shouldHide ? disabledAlpha : 1.0
        }
        if morningReminderSwitch.isOn {
            didSetMorningReminder(self)
        } else {
            viewModel.removeMorningReminders()
        }
    }
    
    @IBAction func eveningReminderToggled(_ sender: Any) {
        let shouldHide = !eveningReminderSwitch.isOn
        self.eveningReminderTimePicker.isEnabled = !shouldHide
        UIView.animate(withDuration: 0.5) {
            self.eveningReminderTimePicker.alpha = shouldHide ? disabledAlpha : 1.0
        }
        if eveningReminderSwitch.isOn {
            didSetEveningReminder(self)
        } else {
            viewModel.removeEveningReminders()            
        }
    }
    
    @IBAction func didSetMorningReminder(_ sender: Any) {
        let components = getComponentsFrom(picker: morningReminderTimePicker)
        viewModel.addMorningReminders(components: components)
    }
    
    @IBAction func didSetEveningReminder(_ sender: Any) {
        let components = getComponentsFrom(picker: eveningReminderTimePicker)
        viewModel.addEveningReminds(components: components)
    }
    
    @IBAction func themeDidChange(_ sender: Any) {
        let selectedIndex = themeSegmentControl.selectedSegmentIndex
        let selectedTheme: ThemeType = selectedIndex == 0 ? .dark : .light
        viewModel.save(theme: selectedTheme)
        let notification = Notification(name: Notification.Name(rawValue: "themeDidChange"),
                                        object: nil,
                                        userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    private lazy var viewModel: SettingsViewModel = {
        return SettingsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleElements()
        applyBackgroundColor()

        userNameTextField.text = viewModel.getUserName()
        userNameTextField.delegate = self
        setupUI()
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "themeDidChange"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.styleElements()
                self.applyBackgroundColor()
            }
        }
    }
    
    private func styleElements() {
        let defaultSizeForPage = SizeType.medium
        nameLabel.applyFont(fontSize: defaultSizeForPage)
        themeLabel.applyFont(fontSize: defaultSizeForPage)
        morningReminderLabel.applyFont(fontSize: defaultSizeForPage)
        eveningReminderLabel.applyFont(fontSize: defaultSizeForPage)
        
        userNameTextField.applyFont(fontSize: defaultSizeForPage)
        userNameTextField.backgroundColor = .clear
        signInButton.applyStyle()
        getNosy.applyStyle()
        
        themeSegmentControl.applyFont(fontSize: defaultSizeForPage)
        
        morningReminderTimePicker.applyFont(fontSize: defaultSizeForPage)
        eveningReminderTimePicker.applyFont(fontSize: defaultSizeForPage)
    }
    
}

extension SettingsViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let displayName = user?.displayName {
            userNameTextField.text = displayName
            viewModel.save(userName: displayName)
            setupAuthenticationButton()
        }
    }
}

private extension SettingsViewController {
    func setupUI() {
        func set(picker: UIDatePicker, with date: Date) {
            picker.setDate(date, animated: true)
            picker.isEnabled = true
            picker.alpha = 1.0
        }
        
        morningReminderSwitch.isOn = false
        eveningReminderSwitch.isOn = false
        morningReminderTimePicker.isEnabled = false
        eveningReminderTimePicker.isEnabled = false
        morningReminderTimePicker.alpha = disabledAlpha
        eveningReminderTimePicker.alpha = disabledAlpha

        guard let settings = viewModel.settings else {
            return
        }
        
        let calendar = Calendar(identifier: .gregorian)
        
        if let morningReminder = settings.morningReminder,
            let userPreferredMorningReminder = calendar.date(from: morningReminder) {
            morningReminderSwitch.isOn = true
            set(picker: morningReminderTimePicker, with: userPreferredMorningReminder)
        }
        
        if let eveningReminder = settings.eveningReminder,
            let userPreferredEveningReminder = calendar.date(from: eveningReminder) {
            eveningReminderSwitch.isOn = true
            set(picker: eveningReminderTimePicker, with: userPreferredEveningReminder)
        }
        
        if let theme = settings.theme {
            let selectedIndex = theme == .dark ? 0 : 1
            themeSegmentControl.selectedSegmentIndex = selectedIndex
        }
        setupAuthenticationButton()
        
    }
    
    func getComponentsFrom(picker: UIDatePicker) -> DateComponents {
        return Calendar.current.dateComponents([.hour, .minute],
                                               from: picker.date)
    }
    
    func setupAuthenticationButton() {
        if viewModel.hasLoggedInUser {
            signInButton.setTitle("Log out", for: .normal)
        } else {
            signInButton.setTitle("Sign in/ Sign up", for: .normal)
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
