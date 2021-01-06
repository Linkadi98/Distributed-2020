//
//  BorderView.swift
//  Sapo
//
//  Created by Kien Nguyen on 1/18/19.
//  Copyright © 2019 DKT Technology JSC. All rights reserved.
//

import UIKit

@IBDesignable
class BorderView: UIView {
    @IBInspectable var topBorder: Bool = true {
        didSet {
            topBorderView.isHidden = !topBorder
            bringSubviewToFront(topBorderView)
        }
    }
    
    @IBInspectable var topBorderWidth: CGFloat = 1.0 {
        didSet {
            topBorderViewHeight.constant = topBorderWidth
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var topBorderMargin: CGFloat = 0 {
        didSet {
            topBorderViewLeading.constant = topBorderMargin
            topBorderViewTrailing.constant = -topBorderMargin
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var topBorderColor: UIColor = UIColor(hex: "#E4E6EF") {
        didSet {
            topBorderView.backgroundColor = topBorderColor
        }
    }
    
    @IBInspectable var bottomBorder: Bool = true {
        didSet {
            bottomBorderView.isHidden = !bottomBorder
            bringSubviewToFront(bottomBorderView)
        }
    }
    
    @IBInspectable var bottomBorderWidth: CGFloat = 1.0 {
        didSet {
            bottomBorderViewHeight.constant = bottomBorderWidth
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var bottomBorderMargin: CGFloat = 0 {
        didSet {
            bottomBorderViewLeading.constant = bottomBorderMargin
            bottomBorderViewTrailing.constant = -bottomBorderMargin
            layoutIfNeeded()
        }
    }
    
    @IBInspectable var bottomBorderColor: UIColor = UIColor(hex: "#E4E6EF") {
        didSet {
            bottomBorderView.backgroundColor = bottomBorderColor
        }
    }
    
    private var topBorderView: UIView!
    private var topBorderViewHeight: NSLayoutConstraint!
    private var topBorderViewLeading: NSLayoutConstraint!
    private var topBorderViewTrailing: NSLayoutConstraint!
    
    private var bottomBorderView: UIView!
    private var bottomBorderViewHeight: NSLayoutConstraint!
    private var bottomBorderViewLeading: NSLayoutConstraint!
    private var bottomBorderViewTrailing: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        topBorderView = buildTopBorderView()
        bottomBorderView = buildBottomBorderView()
        
        topBorder = true
        bottomBorder = true
    }
    
    private func buildTopBorderView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = topBorderColor
        addSubview(view)
        topBorderViewLeading = view.autoPinEdge(toSuperviewEdge: .leading)
        topBorderViewTrailing = view.autoPinEdge(toSuperviewEdge: .trailing)
        view.autoPinEdge(toSuperviewEdge: .top)
        topBorderViewHeight = view.autoSetDimension(.height, toSize: topBorderWidth)
        return view
    }
    
    private func buildBottomBorderView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = bottomBorderColor
        addSubview(view)
        bottomBorderViewLeading = view.autoPinEdge(toSuperviewEdge: .leading)
        bottomBorderViewTrailing = view.autoPinEdge(toSuperviewEdge: .trailing)
        view.autoPinEdge(toSuperviewEdge: .bottom)
        bottomBorderViewHeight = view.autoSetDimension(.height, toSize: bottomBorderWidth)
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if topBorder {
            bringSubviewToFront(topBorderView)
        }
        
        if bottomBorder {
            bringSubviewToFront(bottomBorderView)
        }
    }
}

extension BorderView {
    func setUpColorAndFont(for label: UILabel, color: UIColor, font: UIFont) {
        label.font = font
        label.textColor = color
    }
    
    func makeAttributedText(boldText: String, normalText: String, boldFontSize: CGFloat, normalTextFontSize: CGFloat) -> NSMutableAttributedString {
        let boldAttributed = [NSAttributedString.Key.foregroundColor: UIColor.text,
                              NSAttributedString.Key.font: UIFont.defaultBoldFont(ofSize: .custom(boldFontSize))]
        
        let normalAttributed = [NSAttributedString.Key.foregroundColor: UIColor.text,
                                NSAttributedString.Key.font: UIFont.defaultFont(ofSize: .custom(normalTextFontSize))]
        
        let normalAttributedString = NSAttributedString(string: normalText, attributes: normalAttributed)
        let combineString = NSMutableAttributedString(string: boldText, attributes: boldAttributed)
        combineString.append(normalAttributedString)
        return combineString
    }
}

