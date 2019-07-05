//
//  HistoryCalendarCell.swift
//  OnePercentWin
//
//  Created by David on 27/12/18.
//  Copyright © 2018 David Lam. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var accessoryView: UIView!
}

class IncompleteGoalCell: CustomCell {
    override func awakeFromNib() {
        accessoryView.backgroundColor = HistoryCellModel.incompleteColor
    }
}

class CompleteGoalCell: CustomCell {
    override func awakeFromNib() {
        accessoryView.backgroundColor = HistoryCellModel.completedColor
    }
}

class NoEntryCell: CustomCell {
    override func awakeFromNib() {
        accessoryView.backgroundColor = HistoryCellModel.noEntryColor
    }
}
