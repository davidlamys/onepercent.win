//
//  UIButton+Ext.swift
//  OnePercentWin
//
//  Created by David on 21/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

extension UIButton {
    func applyStyle() {
        backgroundColor = ThemeHelper.defaultOrange()
        setTitleColor(ThemeHelper.textColor(), for: .normal)
        setTitleColor(.gray, for: .disabled)
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
    
    func greyOutIfDisable() {
        alpha = isEnabled ? 1.0 : 0.5
    }
}
