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

let disabledAlpha: CGFloat = 0.5

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak private var morningReminderSwitch: UISwitch!
    @IBOutlet weak private var eveningReminderSwitch: UISwitch!
    @IBOutlet weak private var morningReminderTimePicker: UIDatePicker!
    @IBOutlet weak private var eveningReminderTimePicker: UIDatePicker!
    
    @IBOutlet weak private var userNameTextField: UITextField!
    
    @IBAction func didTapSignIn(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true)
    }
    
    @IBAction func nameTextField(_ sender: Any) {
        if let textField = sender as? UITextField,
            let userName = textField.text {
            UserDefaults.standard.setValue(userName, forKey: "user")
        }
    }
    @IBAction func morningReminderToggled(_ sender: Any) {
        let shouldHide = !morningReminderSwitch.isOn
        self.morningReminderTimePicker.isEnabled = !shouldHide
        UIView.animate(withDuration: 0.5) {
            self.morningReminderTimePicker.alpha = shouldHide ? disabledAlpha : 1.0
        }
        viewModel.removeMorningReminders()
    }
    @IBAction func eveningReminderToggled(_ sender: Any) {
        let shouldHide = !eveningReminderSwitch.isOn
        self.eveningReminderTimePicker.isEnabled = !shouldHide
        UIView.animate(withDuration: 0.5) {
            self.eveningReminderTimePicker.alpha = shouldHide ? disabledAlpha : 1.0
        }
        viewModel.removeEveningReminders()
    }
    
    @IBAction func didSetMorningReminder(_ sender: Any) {
        let components = getComponentsFrom(picker: morningReminderTimePicker)
        viewModel.addMorningReminders(components: components)
    }
    
    @IBAction func didSetEveningReminder(_ sender: Any) {
        let components = getComponentsFrom(picker: eveningReminderTimePicker)
        viewModel.addEveningReminds(components: components)
    }
    
    private lazy var viewModel: SettingsViewModel = {
        return SettingsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = UserDefaults.standard.string(forKey: "user")
        userNameTextField.delegate = self
        setupUI()
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
    }
    
}

extension SettingsViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        self.userNameTextField.text = user?.displayName
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
    }
    
    func getComponentsFrom(picker: UIDatePicker) -> DateComponents {
        return Calendar.current.dateComponents([.hour, .minute],
                                               from: picker.date)
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
