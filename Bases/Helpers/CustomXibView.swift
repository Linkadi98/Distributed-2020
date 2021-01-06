//
//  CustomXibView.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit
import PureLayout

class CustomXibView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
        configViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViews()
        configViews()
    }
    
    private func loadViews() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.autoPinEdgesToSuperviewEdges()
    }
    
    internal func configViews() {
        
    }
}
