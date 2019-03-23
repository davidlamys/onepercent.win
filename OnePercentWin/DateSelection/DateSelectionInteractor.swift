//
//  DateSelectionInteractor.swift
//  OnePercentWin
//
//  Created by David on 2/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DateSelectionInteractor {
    weak var presenter: DateSelectionInteractorOutputConsumer?
    let userService = UserService()
    let userQueryListener = UserGoalQueryListener.shared
    init() {
        userQueryListener.delegate = self        
    }
}

extension DateSelectionInteractor: DateSelectionInteractorProtocol {
    func fetchAllUserGoals() {
        let userId = userService.userId()
        userQueryListener.set(userId: userId)
    }
}

extension DateSelectionInteractor: RepoWrapperDelegate {
    func refreshWith(goals: [DailyGoal]) {
        presenter?.didFinishFetching(goals: goals)
    }
}
