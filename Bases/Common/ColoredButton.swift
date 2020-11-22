//
//  ColoredButton.swift
//  Sapo
//
//  Created by Kien Nguyen on 4/27/18.
//  Copyright © 2018 DKT Technology JSC. All rights reserved.
//

import UIKit

@IBDesignable
class ColoredButton: UIButton {
    
    @IBInspectable var mainColor: UIColor? {
        didSet {
            if mainColor == nil {
                mainColor = .white
            }
            
            updateMainColor()
        }
    }
    
    @IBInspectable var isImageRightAligned: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var highlightedDarkedRatio: CGFloat = 0.15 {
        didSet {
            updateMainColor()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    private func updateMainColor() {
        guard let color = mainColor else {
            return
        }
        
        setBackgroundColor(color, for: .normal)
        let highlightedColor = color.rgba.alpha > 0 ? color.darker(by: highlightedDarkedRatio)
            : UIColor(white: 0, alpha: highlightedDarkedRatio)
        setBackgroundColor(highlightedColor, for: .highlighted)
    }
    
    private func setup() {
        self.adjustsImageWhenHighlighted = false
        mainColor = nil
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.7
        self.titleLabel?.numberOfLines = 2
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
        
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            UIView.transition(with: self,
                              duration: 0.1,
                              options: [ .transitionCrossDissolve, .allowUserInteraction ],
                              animations: {
                                super.isHighlighted = newValue
                              },
                              completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isImageRightAligned, let imageView = self.imageView {
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: bounds.width - imageView.bounds.width - 12,
                                           bottom: 0,
                                           right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: imageView.bounds.width)
        }
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            setBackgroundImage(UIImage.from(color: color), for: state)
        } else {
            setBackgroundImage(nil, for: state)
        }
    }
}
