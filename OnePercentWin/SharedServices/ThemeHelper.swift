//
//  ThemeHelper.swift
//  OnePercentWin
//
//  Created by David on 12/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

class ThemeHelper {
    static func defaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
