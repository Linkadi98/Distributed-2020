//
//  UIView+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

extension UIView {
    
    var nibName: String {
        return String(describing: type(of: self))
    }

    func animateFadeIn(withDuration duration: TimeInterval,
                       completion: ((_ finished: Bool) -> Void)? = nil) {
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func animateFadeOut(withDuration duration: TimeInterval,
                        completion: ((_ finished: Bool) -> Void)? = nil) {
        if self.isHidden {
            return
        }
        
        self.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { finished in
            self.isHidden = true
            completion?(finished)
        })
    }
    
    func addSubviews(_ subviews: UIView...) {
        for view in subviews {
            addSubview(view)
        }
    }
    
    func setCornerRadius(to radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
