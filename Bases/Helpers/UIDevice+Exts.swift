//
//  UIDevice+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

extension UIDevice {
    
    @objc static let isPad = current.userInterfaceIdiom == .pad
    
    @objc static let globalSupportedOrientationMask: UIInterfaceOrientationMask
        = isPad ? .landscape : .portrait
    
    @objc static func setOrientation(_ orientation: UIDeviceOrientation) {
        current.setValue(orientation.rawValue, forKey: "orientation")
    }
}
