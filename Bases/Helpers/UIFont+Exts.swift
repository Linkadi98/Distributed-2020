//
//  UIFont+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

enum CustomFontName: String {
    case helveticaNeue = "HelveticaNeue"
    case helveticaNeueMedium = "HelveticaNeue-Medium"
    case helveticaNeueBold = "HelveticaNeue-Bold"
    case helveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    case helveticaNeueLight = "HelveticaNeue-Light"
    case helveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    case helveticaNeueItalic = "HelveticaNeue-Italic"
}

enum FontSize {
    case small
    case subtitle
    case medium
    case `default`
    case title
    case button
    case largeButton
    case tableTitle
    case tableDescription
    case textInputFloatLabel
    case textInput
    case price
    case superSmall
    case bigTitle
    case mediumSmall
    
    case custom(CGFloat)
    
    var value: CGFloat {
        switch self {
        case .small:
            return 12
        case .subtitle:
            return 13
        case .medium:
            return 15
        case .default:
            return 16
        case .title:
            return 17
        case .button:
            return 15
        case .largeButton:
            return 17
        case .tableTitle:
            return 16
        case .tableDescription:
            return 13
        case .textInputFloatLabel:
            return 13
        case .textInput:
            return 16
        case .price:
            return 25
        case .superSmall:
            return 10
        case .bigTitle:
            return 20
        case .mediumSmall:
            return 11
        case .custom(let value):
            return value
        }
    }
}


extension UIFont {
    static func defaultLightFont(ofSize fontSize: FontSize) -> UIFont {
        return helveticaNeueLight(ofSize: fontSize.value)
    }
    
    static func defaultFont(ofSize fontSize: FontSize) -> UIFont {
        return helveticaNeue(ofSize: fontSize.value)
    }
    
    static func defaultMediumFont(ofSize fontSize: FontSize) -> UIFont {
        return helveticaNeueMedium(ofSize: fontSize.value)
    }
    
    static func defaultBoldFont(ofSize fontSize: FontSize) -> UIFont {
        return helveticaNeueBold(ofSize: fontSize.value)
    }
    
    static func defaultItalicFont(ofSize fontSize: FontSize) -> UIFont {
        return helveticaNeueItalic(ofSize: fontSize.value)
    }
    
    @objc static func helveticaNeueLight(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueLight, size: fontSize)
    }
    
    @objc static func helveticaNeue(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeue, size: fontSize)
    }
    
    @objc static func helveticaNeueMedium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueMedium, size: fontSize)
    }
    
    @objc static func helveticaNeueBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueBold, size: fontSize)
    }
    
    @objc static func helveticaNeueBoldItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueBoldItalic, size: fontSize)
    }
    
    @objc static func helveticaNeueItalic(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(custom: .helveticaNeueItalic, size: fontSize)
    }
    
    convenience init(custom: CustomFontName, size: CGFloat) {
        self.init(name: custom.rawValue, size: size)!
    }
}
