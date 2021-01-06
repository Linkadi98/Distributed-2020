//
//  ShadowView.swift
//  Sapo
//
//  Created by Kien Nguyen on 5/4/18.
//  Copyright © 2018 DKT Technology JSC. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    
    @IBInspectable var shadowCornerRadius: CGFloat = 0.0 {
        didSet {
            didSetShadowCornerRadius()
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    /**
     Disable auto adjust layer.shadowPath on -layoutSubviews.
     If set to `true`, `shadowCornerRadius` will no long works. Defaults `false`.
     */
    @IBInspectable var disableAutomaticallyAdjustShadowPath: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        shadowOffset = CGSize(width: 0, height: 1)
        shadowRadius = 3.0
        shadowOpacity = 0.3
    }
    
    private func didSetShadowCornerRadius() {
        var path: UIBezierPath
        if shadowCornerRadius != 0 {
            path = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadowCornerRadius)
        } else {
            path = UIBezierPath(rect: self.bounds)
        }
        
        self.layer.shadowPath = path.cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !disableAutomaticallyAdjustShadowPath {
            didSetShadowCornerRadius()
        }
    }
}
