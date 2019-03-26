//
//  NotificationCenter+Ext.swift
//  OnePercentWin
//
//  Created by David on 23/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

enum NotificationType: String {
    case themeDidChange
    case userDidChange
    
    fileprivate var name: Notification.Name {
        return Notification.Name(rawValue: rawValue)
    }
    
    fileprivate var notification: Notification {
        return Notification(name: name,
                            object: nil,
                            userInfo: nil)
    }
}

extension NotificationCenter {
    func observeOnMainQueue(for type: NotificationType, onChange: @escaping ((Notification) -> Void)) {
        NotificationCenter.default.addObserver(forName: type.name, object: nil, queue: OperationQueue.main, using: onChange)
    }
    
    func post(for type: NotificationType) {
        NotificationCenter.default.post(type.notification)

    }
}
