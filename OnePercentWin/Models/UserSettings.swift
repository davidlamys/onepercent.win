//
//  UserSettings.swift
//  OnePercentWin
//
//  Created by David on 30/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

struct UserSettings: Codable {
    var userName: String?
    var morningReminder: DateComponents?
    var eveningReminder: DateComponents?
    var theme: ThemeType?
}
