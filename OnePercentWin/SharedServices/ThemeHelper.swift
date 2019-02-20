//
//  ThemeHelper.swift
//  OnePercentWin
//
//  Created by David on 12/1/19.
//  Copyright © 2019 David Lam. All rights reserved.
//

import UIKit

enum SizeType {
    case large
    case medium
    case small
    
    var fontSize: CGFloat {
        switch self {
        case .large: return 27.0
        case .medium: return 21.0
        case .small: return 12.0
        }
    }
}

class ThemeHelper {

    static func defaultFont(fontSize: SizeType) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: fontSize.fontSize)!
    }
    
    static func boldFont(fontSize: SizeType) -> UIFont {
        return UIFont(name: "Roboto-Black", size: fontSize.fontSize)!
    }
    
    static func defaultOrange() -> UIColor {
        return UIColor(rgb: 0xFF9500)
    }
    
    static func textColor() -> UIColor {
        return UIColor.black
    }
}

fileprivate extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
