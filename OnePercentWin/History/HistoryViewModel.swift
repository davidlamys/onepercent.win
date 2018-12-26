//
//  HistoryViewModel.swift
//  OnePercentWin
//
//  Created by David Lam on 22/11/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import Foundation

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
        
        func getUserGoals() -> [DailyGoal] {
            let userId = userService.userId()
            return goals.filter { $0.userId == userId }
        }
        
        visibleGoals = shouldShowAllGoals ? goals: getUserGoals()
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
