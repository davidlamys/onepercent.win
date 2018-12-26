//
//  HistoryViewModel.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit

struct HistoryCellModel {
    enum GoalStatus {
        case notSet
        case incomplete
        case complete
    }
    
    let date: Date
    let goal: DailyGoal?
    
    var dateLabel: String {
        return date.historyCellModelDate
    }
    
    var textLabel: String {
        return goal?.goal ?? "You did not set goal"
    }
    
    var status: GoalStatus {
        guard let goal = goal else {
            return .notSet
        }
        return (goal.completed ?? false) ? .complete : .incomplete
    }
    
    var colorForStatus: UIColor {
        switch self.status {
        case .complete:
            return UIColor.green
        case .incomplete:
            return UIColor.yellow
        case .notSet:
            return UIColor.red
        }
    }
}

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
        
        let dates = startOfMonth
            .allDates(till: currentDate)
            .map { $0.startOfDay }
            .reversed()
        
        return dates.map({ date in
            let goalForDate = goals.filter({ $0.date.startOfDay == date }).first
            return HistoryCellModel(date: date, goal: goalForDate)
        })
    }
}

extension HistoryViewModel: RepoWrapperDelegate {
    func refreshWith(goals: [DailyGoal]) {
        
        self.goals = goals.sorted(by: {
            $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970
        })
        
        delegate?.refreshView()
    }
}

protocol HistoryViewModelDelegate: class {
    func refreshView()
}
