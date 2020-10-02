//
//  UIColor+Extensions.swift
//  What a Brick
//
//  Created by Kuba Florek on 08/09/2020.
//

import Foundation
import UIKit

extension UIColor {
    /// CoreImage of this UIColor
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    /// Components of this UIColor
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
    /// Returns color distance between this and input UIColor
    func colorDistanceBetween(uicolor: UIColor) -> Float {
        let firstColorComponents = self.components
        let secondColorComponents = uicolor.components
        
        return Float(pow(secondColorComponents.red - firstColorComponents.red, 2) + pow(secondColorComponents.green - firstColorComponents.green, 2) + pow(secondColorComponents.blue - firstColorComponents.blue, 2)).squareRoot()
    }
    
    /// Returns dictonary of all brick UIColors with their names
    static func getAllColors() -> [String: UIColor] {
        let colors = ["Black": UIColor(red: 0.04, green: 0.06, blue: 0.09, alpha: 1.00),
                      "White": UIColor(red: 0.97, green: 0.96, blue: 0.98, alpha: 1.00),
                      "Dark Stone Grey": UIColor(red: 0.21, green: 0.25, blue: 0.31, alpha: 1.00),
                      "Bright Yellow": UIColor(red: 0.89, green: 0.83, blue: 0.17, alpha: 1.00),
                      "Bright Red": UIColor(red: 0.65, green: 0.16, blue: 0.13, alpha: 1.00),
                      "Bright Blue": UIColor(red: 0.00, green: 0.18, blue: 0.67, alpha: 1.00),
                      "Bright Orange": UIColor(red: 0.94, green: 0.51, blue: 0.20, alpha: 1.00),
                      "Bright Yellowish-Green": UIColor(red: 0.48, green: 0.78, blue: 0.02, alpha: 1.00),
                      "Medium Stone Grey": UIColor(red: 0.40, green: 0.47, blue: 0.55, alpha: 1.00)]
        
        return colors
    }
    
    /// Returns a color with the given name
    static func getColorByName(_ name: String) -> UIColor {
        let colors = UIColor.getAllColors()
        
        return colors[name]!
    }
}
