//
//  GoalEntryViewModel.swift
//  OnePercentWin
//
//  Created by David on 12/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation

enum GoalEntryMode {
    case add
    case update
}

class GoalEntryViewModel {
    private(set) var wrapper: RepoWrapper!
    private(set) var goal: DailyGoal
    private(set) var lastGoal: DailyGoal?
    private(set) weak var delegate: GoalEntryViewModelDelegate?
    let mode: GoalEntryMode
    
    init(wrapper: RepoWrapper,
         goal: DailyGoal,
         delegate: GoalEntryViewModelDelegate,
         mode: GoalEntryMode) {
        self.wrapper = wrapper
        self.goal = goal
        self.delegate = delegate
        self.mode = mode

        wrapper.delegate = self
    }
    
    func updateGoal(goal goalString: String, reason: String) {
        goal.goal = goalString
        goal.reason = reason
        switch mode {
        case .add:
            wrapper.add(goal)
        case .update:
            wrapper.save(goal)
        }
    }
    
    func updateWithLastGoal() {
        guard let lastGoal = lastGoal else { return }
        goal.goal = lastGoal.goal
        goal.reason = lastGoal.reason
        delegate?.updateView(goal: goal)
    }
}

extension GoalEntryViewModel: RepoWrapperDelegate {
    
    func refreshWith(goals: [DailyGoal]) {
        let userId = UserService().userId()
        let userGoal = goals
            .filter({ $0.userId == userId })
        lastGoal = userGoal.first
        delegate?.refreshView(hasLastGoal: (lastGoal != nil))
    }
}


protocol GoalEntryViewModelDelegate: class {
    func refreshView(hasLastGoal: Bool)
    func updateView(goal: DailyGoal)
}
