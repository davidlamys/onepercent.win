//
//  DateSelectionPresenter.swift
//  OnePercentWin
//
//  Created by David on 2/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation

class DateSelectionPresenter: DateSelectionPresenterProtocol {
    
    weak var dateView: DateSelectionViewProtocol?
    var interactor: DateSelectionInteractorProtocol? {
        didSet {
            interactor?.fetchAllUserGoals()
        }
    }
    var indexPath: NSIndexPath?
    
    private let today = Date().startOfDay
    private let startOfMonth = Date().startOfMonth
    
    private var allDates = Date().startOfMonth.allDates(till: Date().startOfDay)
    private var goalsHashMap = [Date: DailyGoal?]()
    private var allGoalsFromUser = [DailyGoal]() {
        didSet {
            guard let firstEnteredGoal = allGoalsFromUser.last else {
                return
            }
            let firstDate = firstEnteredGoal.date.startOfDay
            goalsHashMap.removeAll()
            allDates = firstDate
                .allDates(till: today)
                .reversed()
        }
    }
    
    func numberOfCellsToPresent() -> Int {
        return allDates.count
    }
    
    func cellModelFor(indexPath: IndexPath) -> DateSelectionCellModelling {
        let date = allDates[indexPath.item]
        
        if let goal = goalsHashMap[date] {
            return DateSelectionCellModel(goal: goal,
                                          date: date)
        } else {
            let goal = allGoalsFromUser.filter({
                $0.date.startOfDay == date
            })
            .first
            goalsHashMap[date] = goal
            return DateSelectionCellModel(goal: goal,
                                          date: date)
        }
    }
    
    func viewDidLoad() {
        interactor?.fetchAllUserGoals()
    }
    
}

extension DateSelectionPresenter: DateSelectionInteractorOutputConsumer {
    func didFinishFetching(goals: [DailyGoal]) {
        allGoalsFromUser = goals
        dateView?.reloadCollectionView()
    }
}
