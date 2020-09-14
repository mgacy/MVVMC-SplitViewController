//
//  ColorCompatibility+Ext.swift
//  MVVMC-SplitViewController
//

import UIKit
import ColorCompatibility

// MARK - RGBA Initializer
extension UIColor {

    /// Creates a color object using the specified opacity and CSS RGB values.
    /// - Parameter r: The red value of the color object. Values below 0 are interpreted as 0 and values above 255 are interpreted as 255.
    /// - Parameter g: The green value of the color object. Values below 0 are interpreted as 0 and values above 255 are interpreted as 255.
    /// - Parameter b: The blue value of the color object. Values below 0 are interpreted as 0 and values above 255 are interpreted as 255.
    /// - Parameter a: The opacity value of the color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0.
    convenience init(r red: Int, g green: Int, b blue: Int, a alpha: CGFloat) {
        self.init(red: UIColor.clampingPercentage(red),
                  green: UIColor.clampingPercentage(green),
                  blue: UIColor.clampingPercentage(blue),
                  alpha: alpha)
    }

    fileprivate static func clampingPercentage(_ value: Int) -> CGFloat {
        if value <= 0 {
            return 0.0
        } else if value >= 255 {
            return 1.0
        } else {
            return CGFloat(value) / 255.0
        }
    }
}

// See https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
extension ColorCompatibility {

    // MARK: - Standard Colors

    // MARK: Adaptable Colors

    /// A blue color that automatically adapts to the current trait environment.
    static var systemBlue: UIColor {
        if #available(iOS 13, *) {
            return .systemBlue
        }
        // Dark
        //return UIColor(r: 10, g: 132, b: 255, a: 1.0)
        // Light
        return UIColor(r: 0, g: 122, b: 255, a: 1.0)
    }

    /// A green color that automatically adapts to the current trait environment.
    static var systemGreen: UIColor {
        if #available(iOS 13, *) {
            return .systemGreen
        }
        // Dark
        //return UIColor(r: 48, g: 209, b: 88, a: 1.0)
        // Light
        return UIColor(r: 52, g: 199, b: 89, a: 1.0)
    }

    /// An indigo color that automatically adapts to the current trait environment.
    static var systemIndigo: UIColor {
        if #available(iOS 13, *) {
            return .systemIndigo
        }
        // Dark
        //return UIColor(r: 94, g: 92, b: 230, a: 1.0)
        // Light
        return UIColor(r: 88, g: 86, b: 214, a: 1.0)
    }

    /// An orange color that automatically adapts to the current trait environment.
    static var systemOrange: UIColor {
        if #available(iOS 13, *) {
            return .systemOrange
        }
        // Dark
        //return UIColor(r: 255, g: 159, b: 10, a: 1.0)
        // Light
        return UIColor(r: 255, g: 149, b: 0, a: 1.0)
    }

    /// A pink color that automatically adapts to the current trait environment.
    static var systemPink: UIColor {
        if #available(iOS 13, *) {
            return .systemPink
        }
        // Dark
        //return UIColor(r: 255, g: 55, b: 95, a: 1.0)
        // Light
        return UIColor(r: 255, g: 45, b: 85, a: 1.0)
    }

    /// A purple color that automatically adapts to the current trait environment.
    static var systemPurple: UIColor {
        if #available(iOS 13, *) {
            return .systemPurple
        }
        // Dark
        //return UIColor(r: 191, g: 90, b: 242, a: 1.0)
        // Light
        return UIColor(r: 175, g: 82, b: 222, a: 1.0)
    }

    /// A red color that automatically adapts to the current trait environment.
    static var systemRed: UIColor {
        if #available(iOS 13, *) {
            return .systemRed
        }
        // Dark
        //return UIColor(r: 255, g: 69, b: 58, a: 1.0)
        // Light
        return UIColor(r: 255, g: 59, b: 48, a: 1.0)
    }

    /// A teal color that automatically adapts to the current trait environment.
    static var systemTeal: UIColor {
        if #available(iOS 13, *) {
            return .systemTeal
        }
        // Dark
        //return UIColor(r: 100, g: 210, b: 255, a: 1.0)
        // Light
        return UIColor(r: 90, g: 200, b: 250, a: 1.0)
    }

    /// A yellow color that automatically adapts to the current trait environment.
    static var systemYellow: UIColor {
        if #available(iOS 13, *) {
            return .systemYellow
        }
        // Dark
        //return UIColor(r: 255, g: 214, b: 10, a: 1.0)
        // Light
        return UIColor(r: 255, g: 204, b: 0, a: 1.0)
    }

}
