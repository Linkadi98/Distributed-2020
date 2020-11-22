//
//  UIColor+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var hexNumber: UInt32 = 0
        scanner.scanHexInt32(&hexNumber)
        let r = (hexNumber & 0xff0000) >> 16
        let g = (hexNumber & 0xff00) >> 8
        let b = hexNumber & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: alpha
        )
    }
}

extension UIColor {
    
    static let primary = UIColor(r: 0, g: 136, b: 255)
    static let error = UIColor(r: 241, g: 64, b: 75)
    static var greenText = UIColor(hex: "0FD186")
    static var successAlert = UIColor(hex: "55C54D")
    static var tableViewCellSelected = UIColor(r: 233, g: 236, b: 247)
    static var dashboardBackground = UIColor(r: 233, g: 239, b: 243)
    static var text = UIColor(hex: "343741")
    static var grayText = UIColor(hex: "8F9096")
    static var icon = UIColor(hex: "8F9096")
    static var grayBackground = UIColor(hex: "F6F7FB")
    static var grayButtonBackground = UIColor(hex: "EFF1F2")
    static var requiredTextFieldPlaceholder = UIColor.error.withAlphaComponent(0.5)
    static var navigationTitle = UIColor(hex: "343741")
    static var activeCustomer = UIColor(hex: "EF8D2D")
    static var inactiveCustomer = UIColor.grayText
    static var sapo = UIColor(red: 0.0,
                              green: 136 / 255.0,
                              blue: 255 / 255.0,
                              alpha: 1.0)
    static var redText = UIColor(hex: "#E3404A")
    static var buttonHighlight = UIColor(white: 0, alpha: 0.065)
    static var placeholderText = UIColor(hex: "#8F9096")
    static var line = UIColor(hex: "#E4E4E4")
    static var focusedInputLine = UIColor(hex: "#0088FF")
    static var barIcon = UIColor(hex: "#666970")
    static var rightNavigator = UIColor(hex: "#C1C2C5")
    static var border = UIColor(hex: "#E4E4E4")
    
    static var obscureText = UIColor(hex: "#BADAF5")
    static var indicatorIcon = UIColor(hex: "#D1D1D1")
    
    static let discounted = UIColor(hex: "#EB3838")
}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 0.3) -> UIColor? {
        return self.adjust(by: abs(percentage * 100) )
    }
    
    func darker(by percentage: CGFloat = 0.3) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 0.3) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage, 1.0),
                           green: min(green + percentage, 1.0),
                           blue: min(blue + percentage, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
