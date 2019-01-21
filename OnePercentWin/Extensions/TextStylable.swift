//
//  TextStylable.swift
//  OnePercentWin
//
//  Created by David on 21/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol TextStylable {
    func applyFont(fontSize: SizeType, color: UIColor?)
}

extension UILabel: TextStylable {
    func applyFont(fontSize: SizeType, color: UIColor? = nil) {
        self.font = ThemeHelper.defaultFont(fontSize: fontSize)
        guard let color = color else { return }
        self.textColor = color
    }
}

extension UITextView: TextStylable {
    func applyFont(fontSize: SizeType, color: UIColor? = nil) {
        self.font = ThemeHelper.defaultFont(fontSize: fontSize)
        guard let color = color else { return }
        self.textColor = color
    }
}
