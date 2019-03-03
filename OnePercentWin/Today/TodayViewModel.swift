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
    private(set) var todayGoal: DailyGoal! = nil
    
    init(delegate: TodayViewModelDelegate) {
        self.delegate = delegate
    }
    
}

extension TodayViewModel: DateSelectionPresenterOutputConsumer {
    func didSelect(date: Date, goal: DailyGoal?) {
        self.todayGoal = goal
        self.delegate?.setup(todayGoal: goal)
    }
}

protocol TodayViewModelDelegate: class {
    func setup(todayGoal: DailyGoal?)
}
