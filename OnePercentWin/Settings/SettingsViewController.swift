//
//  SettingsViewController.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

let disabledAlpha: CGFloat = 0.5

final class SettingsViewController: UIViewController {
    
    @IBOutlet weak private var morningReminderSwitch: UISwitch!
    @IBOutlet weak private var eveningReminderSwitch: UISwitch!
    @IBOutlet weak private var morningReminderTimePicker: UIDatePicker!
    @IBOutlet weak private var eveningReminderTimePicker: UIDatePicker!
    
    @IBAction func morningReminderToggled(_ sender: Any) {
        let shouldHide = !morningReminderSwitch.isOn
        self.morningReminderTimePicker.isEnabled = !shouldHide
        UIView.animate(withDuration: 0.5) {
            self.morningReminderTimePicker.alpha = shouldHide ? disabledAlpha : 1.0
        }
    }
    
    @IBAction func eveningReminderToggled(_ sender: Any) {
        let shouldHide = !eveningReminderSwitch.isOn
        self.eveningReminderTimePicker.isEnabled = !shouldHide
        UIView.animate(withDuration: 0.5) {
            self.eveningReminderTimePicker.alpha = shouldHide ? disabledAlpha : 1.0
        }
    }
    
    @IBAction func didSetMorningReminder(_ sender: Any) {
    }
    
    @IBAction func didSetEveningReminder(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

private extension SettingsViewController {
    func setupUI() {
        morningReminderSwitch.isOn = false
        eveningReminderSwitch.isOn = false
        morningReminderTimePicker.isEnabled = false
        eveningReminderTimePicker.isEnabled = false
        morningReminderTimePicker.alpha = disabledAlpha
        eveningReminderTimePicker.alpha = disabledAlpha
    }
}
