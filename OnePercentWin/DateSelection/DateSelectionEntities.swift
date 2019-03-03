//
//  DateSelectionEntities.swift
//  OnePercentWin
//
//  Created by David on 2/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import Foundation
import UIKit

struct DateSelectionCellModel {
    let goal: DailyGoal?
    let date: Date
}

extension DateSelectionCellModel: DateSelectionCellModelling {
    var goalStatus: GoalStatus {
        return goal.status
    }
    var dateString: String {
        return date.dateString
    }
    
    var dayString: String {
        return date.dayString
    }
    
    var monthString: String {
        return date.monthString
    }
    
    var colorForAccessory: UIColor {
        return goal.colorForStatus
    }
}
