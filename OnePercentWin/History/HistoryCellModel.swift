//
//  HistoryCellModel.swift
//  OnePercentWin
//
//  Created by David on 12/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

struct HistoryCellModel {
    static let completedColor = UIColor.green
    static let incompleteColor = UIColor.yellow
    static let noEntryColor = UIColor.red
    
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
        return (goal.completed) ? .complete : .incomplete
    }
    
    var colorForStatus: UIColor {
        switch self.status {
        case .complete:
            return HistoryCellModel.completedColor
        case .incomplete:
            return HistoryCellModel.incompleteColor
        case .notSet:
            return HistoryCellModel.noEntryColor
        }
    }
}
