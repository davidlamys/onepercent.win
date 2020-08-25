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
    weak var outputConsumer: DateSelectionPresenterOutputConsumer?
    weak var interactor: DateSelectionInteractorProtocol? {
        didSet {
            interactor?.fetchAllUserGoals()
        }
    }
    private(set) var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    private var today: Date {
        return Date().startOfDay
    }
    
    private var displayDates: [Date] = [Date().startOfDay]
    private var goalsHashMap = [Date: DailyGoal?]()
    private var allGoalsFromUser = [DailyGoal]() {
        didSet {
            goalsHashMap.removeAll()
            guard let firstEnteredGoal = allGoalsFromUser.last else {
                selectedIndexPath = IndexPath(row: 0, section: 0)
                displayDates = [today]
                return
            }
            
            let tomorrow = Date.tomorrow()
            let lastDate: Date = self.needDatesTillTomorrow(latestGoal: allGoalsFromUser.first!) ? tomorrow : today
            
            displayDates = firstEnteredGoal.date.startOfDay
                .allDates(till: lastDate)
                .reversed()
        }
    }
    
    private func needDatesTillTomorrow(latestGoal: DailyGoal) -> Bool {
        let tomorrow = Date.tomorrow()
        if latestGoal.date.startOfDay == tomorrow {
            return true
        }
        if latestGoal.date.startOfDay == today && latestGoal.isCompleted {
            return true
        }
        return false
    }
    
    func numberOfCellsToPresent() -> Int {
        return displayDates.count
    }
    
    func cellModelFor(indexPath: IndexPath) -> DateSelectionCellModelling {
        if displayDates.count < indexPath.item {
            print("shit")
            return DateSelectionCellModel(goal: nil, date: Date())
        }
        let date = displayDates[indexPath.item]
        
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
    
    func setupPresenter() {
        NotificationCenter.default.observeOnMainQueue(for: .userDidChange) { _ in
            self.initialSetup()
        }
        initialSetup()
    }
    
    func initialSetup() {
        goalsHashMap.removeAll()
        allGoalsFromUser = []
        displayDates = [today]
        interactor?.fetchAllUserGoals()
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        updateConsumer()
    }
}

extension DateSelectionPresenter: DateSelectionInteractorOutputConsumer {
    func didFinishFetching(goals: [DailyGoal]) {
        allGoalsFromUser = goals
        dateView?.reloadCollectionView()
        updateConsumer()
    }
}

// MARK: - Helper methods
fileprivate extension DateSelectionPresenter {
    func updateConsumer() {
        guard let cellModel = cellModelFor(indexPath: selectedIndexPath) as? DateSelectionCellModel else {
            fatalError("hash map is no longer provider us with DateSelectionCellModel")
        }
        outputConsumer?.didSelect(date: cellModel.date,
                                  goal: cellModel.goal)
    }
}
