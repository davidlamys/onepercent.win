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
    func applyFont(fontSize: SizeType, color: UIColor? = .black) {
        self.font = ThemeHelper.defaultFont(fontSize: fontSize)
        guard let color = color else { return }
        self.textColor = color
    }
    
    func applyBoldFont(fontSize: SizeType, color: UIColor? = .black) {
        self.font = ThemeHelper.boldFont(fontSize: fontSize)
        guard let color = color else { return }
        self.textColor = color
    }
}

extension UITextView: TextStylable {
    func applyFont(fontSize: SizeType, color: UIColor? = .black) {
        self.font = ThemeHelper.defaultFont(fontSize: fontSize)
        guard let color = color else { return }
        self.textColor = color
    }
}

extension UIViewController {
    func applyBackgroundColor() {
        self.view.backgroundColor = .white
    }
}
