//
//  Extension UIColor.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 23.06.2022.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: 1
        )
    }
    
    // rgba(3, 169, 244, 1)
    static var customBlueColor: UIColor {
        UIColor(red: 3, green: 169, blue: 244)
    }
    
    //rgba(85, 85, 85, 1)
    static var textLabelForCells: UIColor {
        UIColor(red: 85, green: 85, blue: 85)
    }
    
    //rgba(51, 51, 51, 1)
    static var textLabel: UIColor {
        UIColor(red: 51, green: 51, blue: 51)
    }
}
