//
//  HistoryViewModel.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

class HistoryViewModel {
    weak var delegate: HistoryViewModelDelegate?
    var userService: UserService
    
    var shouldShowAllGoals: Bool = false {
        didSet {
            updateVisibleGoals()
        }
    }

    
    var visibleGoals: [DailyGoal] = [] {
        didSet {
            delegate?.refreshView()
        }
    }
    private var cachedGoals: [DailyGoal] = []
    private let wrapper: RepoWrapper!
    private var goals: [DailyGoal] = [] {
        didSet {
            updateVisibleGoals()
        }
    }
    
    init(delegate: HistoryViewModelDelegate,
         userService: UserService) {
        self.delegate = delegate
        self.userService = userService
        wrapper = RepoWrapper.shared
        wrapper.delegate = self
    }
    
    private func updateVisibleGoals() {
        visibleGoals = shouldShowAllGoals ? goals: getUserGoals()
    }
    
    private func getUserGoals() -> [DailyGoal] {
        let userId = userService.userId()
        return goals.filter { $0.userId == userId }
    }
    
    func generateCellModels() -> [HistoryCellModel] {
        let goals = getUserGoals()
        let currentDate = Date().startOfDay
        let startOfMonth = Date().startOfMonth
        let dateOfFirstGoal = goals.last?.date.startOfDay
        
        let dates = (dateOfFirstGoal ?? startOfMonth)
            .allDates(till: currentDate)
            .map { $0.startOfDay }
            .reversed()

        var goalDict: [Date: DailyGoal] = [:]
        
        for goal in goals {
            goalDict[goal.date.startOfDay] = goal
        }
        
        return dates.map({
            HistoryCellModel(date: $0, goal: goalDict[$0])
        })

    }
}

extension HistoryViewModel: RepoWrapperDelegate {
    func refreshWith(goals: [DailyGoal]) {
        
        self.goals = goals
        if self.cachedGoals != self.goals {
            delegate?.refreshView()
            cachedGoals = self.goals
        }
    }
}

protocol HistoryViewModelDelegate: class {
    func refreshView()
}
