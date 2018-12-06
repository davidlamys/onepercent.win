//
//  TodayViewModel.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

struct TodayViewModel {
    weak var delegate: TodayViewModelDelegate?
    var wrapper: RepoWrapper!
    var goal: DailyGoal! = nil
    
    init(wrapper: RepoWrapper, delegate: TodayViewModelDelegate) {
        self.wrapper = wrapper
        self.delegate = delegate
    }
    
    func addGoal(goal:String, reason: String) {
        let createdBy = UserDefaults.standard.string(forKey: "user") ?? "Putu"
        let goal = DailyGoal(goal: goal,
                             reason: reason,
                             date: Date(),
                             createdBy: createdBy)
        wrapper.add(goal)
    }
    
    mutating func updateGoal(goal: String, reason: String) {
        self.goal.goal = goal
        self.goal.reason = reason
        self.goal.date = Date()
        wrapper.save(self.goal)
    }
}


protocol TodayViewModelDelegate: class {
    func setup(goal: DailyGoal)
}
