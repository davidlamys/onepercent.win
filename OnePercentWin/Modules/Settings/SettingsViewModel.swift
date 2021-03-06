//
//  SettingsViewModel.swift
//  OnePercentWin
//
//  Created by David on 29/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation
import UserNotifications

struct SettingsViewModel {
    private let morningRemindersIdentifier = "winInTheDay"
    private let eveningRemindersIdentifier = "celebrateAtNight"
    
    private let userDefaultsWrapper = UserDefaultsWrapper()
    private let userService = UserService()
    
    private(set) var settings: UserSettings? {
        didSet {
            userDefaultsWrapper.save(settings: settings)
        }
    }
    
    var hasLoggedInUser: Bool {
        return userService.hasLoggedInUser()
    }
    
    init() {
        settings = userDefaultsWrapper.getSettings()
    }
    
    func save(userName: String) {
        userService.updateDisplayName(to: userName)
        userDefaultsWrapper.save(userName: userName)
    }
    
    mutating func save(theme: ThemeType) {
        if settings == nil {
            settings = UserSettings()
        }
        settings?.theme = theme
        userDefaultsWrapper.save(theme: theme)
    }
    
    func getUserName() -> String? {
        return userDefaultsWrapper.getUserName()
    }
    
    mutating func addMorningReminders(components: DateComponents) {
        removeMorningReminders()
        
        if settings == nil {
            settings = UserSettings()
        }
        settings?.morningReminder = components
        userDefaultsWrapper.save(settings: settings)

        let content = UNMutableNotificationContent.init()
        content.title = "Set up your day for victory!!!"
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: morningRemindersIdentifier,
                                            content: content,
                                            trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    mutating func addEveningReminds(components: DateComponents) {
        removeEveningReminders()
        
        if settings == nil {
            settings = UserSettings()
        }
        settings?.eveningReminder = components
        userDefaultsWrapper.save(settings: settings)

        let content = UNMutableNotificationContent.init()
        content.title = "Time to review your day. :)"
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: eveningRemindersIdentifier,
                                            content: content,
                                            trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    mutating func removeMorningReminders() {
        settings?.morningReminder = nil
        userDefaultsWrapper.save(settings: settings)
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [morningRemindersIdentifier])
    }
    mutating func removeEveningReminders() {
        settings?.eveningReminder = nil
        userDefaultsWrapper.save(settings: settings)
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [eveningRemindersIdentifier])
    }
    
    func signOutUser() {
        userService.signOutUser()
    }
    
    mutating func didAuthenticateUser(displayName: String) {
        save(userName: displayName)
        userService.didAuthenticateUser()
    }
}

