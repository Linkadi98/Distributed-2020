//
//  NoBorderWithPaddingTextField.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

class NoBorderWithPaddingTextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 8.0
    @IBInspectable var paddingRight: CGFloat = 8.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft,
                      y: 0,
                      width: bounds.width - paddingLeft - paddingRight,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
