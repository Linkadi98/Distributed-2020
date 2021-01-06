//
//  MPFloatLabeledSelectableTextField.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import Foundation
import UIKit

class MPFloatLabeledSelectableTextField: CustomXibView, UITextFieldDelegate {
    
    @IBOutlet weak var floatLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBInspectable var placeHolder: String = "" {
        didSet {
            floatLabel.text = placeHolder
            textField.placeholder = placeHolder
        }
    }
    
    var text: String? {
        textField.text
    }
    
    private var floatLabelShouldHide: Bool = true
    
    private var floatLabelColor: UIColor = .grayText {
        didSet {
            
            UIView.transition(with: floatLabel,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: {
                self.floatLabel.textColor = self.floatLabelColor
            })
        }
    }
    
    private var textFieldHasValue: Bool {
        return !(textField.text?.isEmpty ?? true)
    }

    override func configViews() {
        super.configViews()
        
        textField.delegate = self
        textField.autoSetDimension(.height, toSize: 44)
        
        leftView.isHidden = true
        rightView.isHidden = true
        
        floatLabel.font = .defaultMediumFont(ofSize: .subtitle)
        textField.font = .defaultFont(ofSize: .medium)
        textField.textColor = .text
        
        
        floatLabel.isHidden = floatLabelShouldHide
        
        separatorView.backgroundColor = .line
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        flashLabel(shouldFlashLabel: !textFieldHasValue)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        floatLabelColor = .sapo
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        floatLabelColor = .grayText
    }
    
    func installLeftView(with contentView: UIView, insets: UIEdgeInsets) {
        leftView.isHidden = false
        leftView.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
    func installRightView(with contentView: UIView, insets: UIEdgeInsets) {
        rightView.isHidden = false
        rightView.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges(with: insets)
    }
    
    private func flashLabel(shouldFlashLabel: Bool) {
        guard floatLabelShouldHide != shouldFlashLabel else { return }
        
        floatLabelShouldHide = shouldFlashLabel
        
        floatLabelColor = textFieldHasValue ? .sapo : .grayText
        floatLabelShouldHide
            ? floatLabel.animateFadeOut(withDuration: 0.2)
            : floatLabel.animateFadeIn(withDuration: 0.2)
    }
}
