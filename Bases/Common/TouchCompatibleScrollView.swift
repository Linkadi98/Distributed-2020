//
//  TouchCompatibleScrollView.swift
//  Sapo
//
//  Created by Kien Nguyen on 5/13/18.
//  Copyright © 2018 DKT Technology JSC. All rights reserved.
//

import UIKit

/**
 * Use this subclass to keep scrolling behaviour
 * when have UIControl (UIButton, UITableViewCell, etc.) inside UIScrollView
 */
class TouchCompatibleScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        delaysContentTouches = false
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
    
}
