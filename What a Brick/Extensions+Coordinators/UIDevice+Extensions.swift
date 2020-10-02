//
//  UIDevice+Extensions.swift
//  What a Brick
//
//  Created by Kuba Florek on 13/09/2020.
//

import SwiftUI

extension UIDevice {
    /// Returns true if device has notch
    static func hasNotch() -> Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
