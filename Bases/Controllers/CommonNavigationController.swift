//
//  BaseNavigationController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

class CommonNavigationController: UINavigationController {
    
    @objc class func withRootController(_ viewController: UIViewController) -> CommonNavigationController {
        return CommonNavigationController(rootViewController: viewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        navigationBar.backIndicatorImage = UIImage(named: "BackIcon")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackIcon")
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .icon
        
        navigationBar.shadowImage = UIImage()
        let backgroundImage = UIImage.from(color: .white)
        navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationBar.setBackgroundImage(backgroundImage, for: .compact)
        
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationBar.layer.shadowRadius = 3.0
        navigationBar.layer.shadowOpacity = 0.12
        navigationBar.layer.masksToBounds = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .done, target: nil, action: nil)
        
        super.pushViewController(viewController, animated: animated)
    }
    
    static func rootViewController(_ vc: UIViewController) -> CommonNavigationController {
        return CommonNavigationController(rootViewController: vc)
    }
}
