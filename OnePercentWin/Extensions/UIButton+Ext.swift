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
        self.backgroundColor = ThemeHelper.defaultOrange()
        self.setTitleColor(.black, for: .normal)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    func greyOutIfDisable() {
        self.alpha = self.isEnabled ? 1.0 : 0.5
    }
}
