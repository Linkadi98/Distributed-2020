//
//  RoundedShadowView.swift
//  Sapo
//
//  Created by Kien Nguyen on 5/4/18.
//  Copyright © 2018 DKT Technology JSC. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedShadowView: UIView {
    
    private var __shadowView: ShadowView?
    var shadowView: ShadowView {
        if __shadowView == nil {
            let view = ShadowView(frame: .zero)
            view.shadowCornerRadius = 4.0
            view.shadowOffset = CGSize(width: 0, height: 0.5)
            view.shadowOpacity = 0.2
            view.shadowRadius = 1.0
            __shadowView = view
        }
        
        return __shadowView!
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            shadowView.shadowCornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return shadowView.shadowRadius
        }
        
        set {
            shadowView.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return shadowView.shadowOpacity
        }
        
        set {
            shadowView.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return shadowView.shadowOffset
        }
        
        set {
            shadowView.shadowOffset = newValue
        }
    }
    
    var shadowColor: UIColor? {
        get {
            if let cgColor = shadowView.layer.shadowColor {
                return UIColor(cgColor: cgColor)
            }
            
            return nil
        }
        
        set {
            shadowView.layer.shadowColor = newValue?.cgColor
        }
    }
    
    override var isHidden: Bool {
        get {
            super.isHidden
        }
        set {
            super.isHidden = newValue
            shadowView.isHidden = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            superview.insertSubview(shadowView, belowSubview: self)
            shadowView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    override func removeFromSuperview() {
        __shadowView?.removeFromSuperview()
        __shadowView = nil
        
        super.removeFromSuperview()
    }
    
    deinit {
        __shadowView?.removeFromSuperview()
        __shadowView = nil
    }
    
}

extension RoundedShadowView {
    func `default`() {
        cornerRadius = 8
        shadowRadius = 4
        shadowOffset = .init(width: 1, height: 1)
        shadowOpacity = 0.12
    }
}
