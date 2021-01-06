//
//  NoBorderWithPaddingTextField.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

class NoBorderWithPaddingTextField: UITextField {
    
    enum ViewDirection {
        case right, left
    }
    
    private var underline = UIView(frame: .zero)
    
    @IBInspectable var paddingLeft: CGFloat = 8.0
    @IBInspectable var paddingRight: CGFloat = 8.0
    
    private var isRightViewEnabled: Bool {
        return rightView != nil && rightViewMode == .always
    }
    
    private var isLeftViewEnabled: Bool {
        return leftView != nil && leftViewMode == .always
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addView(_ view: UIView, to direction: ViewDirection) {
        switch direction {
        case .left:
            leftView = view
            leftViewMode = .always
        case .right:
            rightView = view
            rightViewMode = .always
        }
    
        layoutIfNeeded()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if isLeftViewEnabled {
            paddingLeft = leftView!.bounds.width + 8
        }
        
        if isRightViewEnabled {
            paddingRight = rightView!.bounds.width + 8
        }
        
        return CGRect(x: bounds.origin.x + paddingLeft,
                      y: 0,
                      width: bounds.width - paddingLeft - paddingRight,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

class UnderlineTextField: UIView {
    
    private var textField: NoBorderWithPaddingTextField!
    private var underline: UIView!
    
    var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    var rightView: UIView? {
        didSet {
            if let rightView = rightView {
                textField.addView(rightView, to: .right)
            }
        }
    }
    
    var leftView: UIView? {
        didSet {
            if let leftView = leftView {
                textField.addView(leftView, to: .left)
            }
        }
    }
    
    var isPasswordEnabled: Bool = false {
        didSet {
            textField.isSecureTextEntry = isPasswordEnabled
        }
    }
    
    var font: UIFont? {
        didSet {
            textField.font = font
        }
    }
    
    var text: String? {
        textField.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        textField = .init(frame: .zero)
        underline = .init(frame: .zero)
        
        addSubviews(textField, underline)
        
        textField.autoSetDimension(.height, toSize: 48)
        underline.autoSetDimension(.height, toSize: 1)
        
        textField.textColor = .text
        
        underline.backgroundColor = .line
        
        textField.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        underline.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        
        underline.autoPinEdge(.top, to: .bottom, of: textField)
    }
}
