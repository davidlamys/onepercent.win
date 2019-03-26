//
//  TextStylable.swift
//  OnePercentWin
//
//  Created by David on 21/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

protocol TextStylable: AnyObject {
    func setFont(_ font: UIFont)
    func setTextColor(_ color: UIColor)
    func applyFont(fontSize: SizeType, color: UIColor?)
}

extension TextStylable {
    func applyFont(fontSize: SizeType, color: UIColor? = ThemeHelper.textColor()) {
        setFont(ThemeHelper.defaultFont(fontSize: fontSize))
        guard let color = color else { return }
        setTextColor(color)
    }
    
    func applyBoldFont(fontSize: SizeType, color: UIColor? = ThemeHelper.textColor()) {
        setFont(ThemeHelper.boldFont(fontSize: fontSize))
        guard let color = color else { return }
        setTextColor(color)
    }
}

extension UILabel: TextStylable {
    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
    
    func setFont(_ font: UIFont) {
        self.font = font
    }
}

extension UITextView: TextStylable {
    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
    
    func setFont(_ font: UIFont) {
        self.font = font
    }
}

extension UITextField: TextStylable {
    func setTextColor(_ color: UIColor) {
        self.textColor = color
    }
    
    func setFont(_ font: UIFont) {
        self.font = font
    }
}

extension UIDatePicker: TextStylable {
    func setFont(_ font: UIFont) {
        return
    }
    
    func setTextColor(_ color: UIColor) {
        setValue(false, forKey: "highlightsToday")
        setValue(color, forKeyPath: "textColor")
    }
}

extension UISegmentedControl: TextStylable {
    func setFont(_ font: UIFont) {
        setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    func setTextColor(_ color: UIColor) {
        tintColor = color
    }
}

extension UIViewController {
    func applyBackgroundColor() {
        view.backgroundColor = ThemeHelper.backgroundColor()
    }
}
