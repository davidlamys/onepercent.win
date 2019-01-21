//
//  GoalEntryViewModel.swift
//  OnePercentWin
//
//  Created by David on 12/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation

class GoalEntryViewModel {
    private(set) var wrapper: RepoWrapper!
    private(set) var goal: DailyGoal
    private(set) var lastGoal: DailyGoal?
    private(set) weak var delegate: GoalEntryViewModelDelegate?
    
    init(wrapper: RepoWrapper,
         goal: DailyGoal,
         delegate: GoalEntryViewModelDelegate) {
        self.wrapper = wrapper
        self.goal = goal
        self.delegate = delegate
        self.wrapper.delegate = self
    }
    
    func updateGoal(goal: String, reason: String) {
        self.goal.goal = goal
        self.goal.reason = reason
        wrapper.save(self.goal)
    }
    
    func updateWithLastGoal() {
        guard let lastGoal = lastGoal else { return }
        self.goal.goal = lastGoal.goal
        self.goal.reason = lastGoal.reason
        delegate?.updateView(goal: self.goal)
    }
}

extension GoalEntryViewModel: RepoWrapperDelegate {
    
    func refreshWith(goals: [DailyGoal]) {
        let userId = UserService().userId()
        let userGoal = goals
            .filter({ $0.userId == userId })
        self.lastGoal = userGoal.first
        delegate?.refreshView(hasLastGoal: (self.lastGoal != nil))
    }
}


protocol GoalEntryViewModelDelegate: class {
    func refreshView(hasLastGoal: Bool)
    func updateView(goal: DailyGoal)
}
