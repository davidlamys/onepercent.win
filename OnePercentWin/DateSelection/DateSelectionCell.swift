//
//  DateSelectionCell.swift
//  OnePercentWin
//
//  Created by David on 3/3/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

class DateSelectionCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var accessoryView: UIView!
    
    var cellModel: DateSelectionCellModelling! {
        didSet {
            dayLabel.text = cellModel.dayString
            dateLabel.text = cellModel.dateString
            monthLabel.text = cellModel.monthString
            if accessoryView.backgroundColor == nil {
                accessoryView.backgroundColor = cellModel?.colorForAccessory
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            configureFor(selected: isSelected)
        }
    }
    
    private func configureFor(selected: Bool) {
        self.backgroundColor = selected ? accessoryView.backgroundColor : .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func awakeFromNib() {
        accessoryView.backgroundColor = cellModel?.colorForAccessory
    }
}
