//
//  AlertView.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import Foundation
import SwiftMessages
import NVActivityIndicatorView

class LoadingView: UIView {
    
    private var title: UILabel = UILabel()
    private var subTitle = UILabel()
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        let indicator = NVActivityIndicatorView(frame: .init(x: 0, y: 0,
                                                             width: 32, height: 32),
                                                type: .circleStrokeSpin,
                                                color: .sapo, padding: 0)
        
        view.addSubview(indicator)
        view.autoSetDimension(.height, toSize: 64)
        view.backgroundColor = .red
        indicator.autoCenterInSuperview()
        indicator.startAnimating()
        
        return view
    }()
    
    private let width = UIScreen.main.bounds.width * 0.6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configViews()
    }
    
    private func configViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(with: .init(top: 8, left: 8, bottom: 0, right: 8))
        
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subTitle)
        stackView.addArrangedSubview(loadingView)
        
        title.font = .defaultMediumFont(ofSize: .default)
        subTitle.font = .defaultFont(ofSize: .subtitle)
        title.textColor = .text
        subTitle.textColor = .text
        
        title.isHidden = title.text == nil
        subTitle.isHidden = subTitle.text == nil
        loadingView.isHidden = false
        
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        
        backgroundColor = .white
        
        let widthConstraint = autoSetDimension(.width, toSize: width)
        widthConstraint.priority = .defaultHigh
        
        title.setContentCompressionResistancePriority(.required, for: .vertical)
        subTitle.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setTitle(_ title: String?) {
        self.title.text = title
        self.title.isHidden = title == nil
    }
    
    func setSubTitle(_ subTitle: String?) {
        self.subTitle.text = subTitle
        self.subTitle.isHidden = subTitle == nil
    }
}
