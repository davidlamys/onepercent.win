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
    private(set) var todayGoal: DailyGoal! = nil
    private(set) var lastGoal: DailyGoal! = nil
    
    init(wrapper: RepoWrapper, delegate: TodayViewModelDelegate) {
        self.wrapper = wrapper
        self.delegate = delegate
    }
    
    func addGoal(goal:String, reason: String) {
        guard self.todayGoal == nil else {
            self.updateGoal(goal: goal, reason: reason)
            return
        }
        let createdBy = UserDefaults.standard.string(forKey: "user") ?? "Putu"
        let goal = DailyGoal(goal: goal,
                             reason: reason,
                             date: Date(),
                             createdBy: createdBy,
                             userId: UserService().userId())
        wrapper.add(goal)
        self.todayGoal = goal
        delegate?.setup(todayGoal: goal,
                        lastGoal: self.lastGoal)
    }
    
    func repeatLastGoal() {
        guard self.lastGoal != nil && self.todayGoal == nil else {
            return
        }
        addGoal(goal: lastGoal.goal, reason: lastGoal.reason)
    }
    
    func updateGoal(goal: String, reason: String) {
        self.todayGoal.goal = goal
        self.todayGoal.reason = reason
        self.todayGoal.date = Date()
        wrapper.save(self.todayGoal)
        
        delegate?.setup(todayGoal: self.todayGoal,
                        lastGoal: self.lastGoal)
    }
    
    func toggleGoalCompletion() {
        self.todayGoal.completed = !(self.todayGoal.completed ?? false)
        wrapper.save(self.todayGoal)
        delegate?.setup(todayGoal: self.todayGoal,
                        lastGoal: self.lastGoal)
    }
}

extension TodayViewModel: RepoWrapperDelegate {
    
    func refreshWith(goals: [DailyGoal]) {
        let userId = UserService().userId()
        let userGoal = goals
            .filter({ $0.userId == userId })
        
        let todayGoal = userGoal.first(where: { $0.prettyDate == Date().prettyDate })
        
        self.lastGoal = userGoal.first
        self.todayGoal = todayGoal
        delegate?.setup(todayGoal: todayGoal,
                        lastGoal: lastGoal)
        
    }
}

protocol TodayViewModelDelegate: class {
    func setup(todayGoal: DailyGoal?, lastGoal: DailyGoal?)
}
