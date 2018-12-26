//
//  TodayViewModel.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

class TodayViewModel {
    weak var delegate: TodayViewModelDelegate?
    var wrapper: RepoWrapper!
    var goal: DailyGoal! = nil
    
    init(wrapper: RepoWrapper, delegate: TodayViewModelDelegate) {
        self.wrapper = wrapper
        self.delegate = delegate
    }
    
    func addGoal(goal:String, reason: String) {
        guard self.goal == nil else {
            self.updateGoal(goal: goal, reason: reason)
            return
        }
        let createdBy = UserDefaults.standard.string(forKey: "user") ?? "Putu"
        let goal = DailyGoal(id: UUID.init().uuidString,
                             goal: goal,
                             reason: reason,
                             date: Date(),
                             createdBy: createdBy,
                             userId: UserService().userId(),
                             completed: false)
        wrapper.add(goal)
        self.goal = goal
        delegate?.setup(goal: goal)
    }
    
    func updateGoal(goal: String, reason: String) {
        self.goal.goal = goal
        self.goal.reason = reason
        self.goal.date = Date()
        wrapper.save(self.goal)
        
        delegate?.setup(goal: self.goal)
    }
    
    func toggleGoalCompletion() {
        self.goal.completed = !(self.goal.completed ?? false)
        wrapper.save(self.goal)
        delegate?.setup(goal: self.goal)
    }
}

extension TodayViewModel: RepoWrapperDelegate {
    
    func refreshWith(goals: [DailyGoal]) {
        let user = UserDefaults.standard.string(forKey: "user") ?? ""
        if let todayGoal = goals
            .filter({ $0.createdBy == user})
            .filter({ $0.prettyDate == Date().prettyDate })
            .first {
            self.goal = todayGoal
            delegate?.setup(goal: todayGoal)
        }
    }
}

protocol TodayViewModelDelegate: class {
    func setup(goal: DailyGoal)
}
