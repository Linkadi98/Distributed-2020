//
//  BaseTabbarController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

enum TabbarViewControllerTags: Int, CaseIterable {
    case tasks = 0
    case userInfo
    case report
    
    var tabbarItemImageName: String {
        switch self {
        case .userInfo:
            return ""
        case .report:
            return ""
        case .tasks:
            return "ic_incident"
        }
    }
    
    var tabbarItemTitle: String {
        switch self {
        case .userInfo:
            return ""
        case .report:
            return "2"
        case .tasks:
            return "Danh sách sự cố"
        }
    }
}

class CommonTabbarController: UITabBarController, UITabBarControllerDelegate {
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override var shouldAutorotate: Bool {
        if let vc = selectedViewController {
            return vc.shouldAutorotate
        }
        
        return super.shouldAutorotate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = .sapo
        tabBar.isTranslucent = false
        
        tabBar.shadowImage = UIImage()
        let backgroundImage = UIImage.from(color: .white)
        tabBar.backgroundImage = backgroundImage
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        tabBar.layer.shadowRadius = 3.0
        tabBar.layer.shadowOpacity = 0.12
        tabBar.layer.masksToBounds = false
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = UIColor.barIcon
        }
        
        delegate = self
 
        var viewControllers: [UIViewController] = []
        
        for index in 0..<TabbarViewControllerTags.allCases.count {
            if let tag = TabbarViewControllerTags(rawValue: index) {
                let vc = CommonTabbarController.viewController(tag: tag, isRootViewController: true)
                viewControllers.append(vc)
            }
        }
        
        self.viewControllers = viewControllers
    }
    
    static func viewController(tag: TabbarViewControllerTags, isRootViewController: Bool) -> UIViewController {
        let viewController: UIViewController
        
        switch tag {
        case .userInfo:
            viewController = UIViewController()
        case .report:
            viewController = UIViewController()
        case .tasks:
            viewController = IncidentTasksViewController()
        }
        
        viewController.tabBarItem.image = UIImage(named: tag.tabbarItemImageName)?.alwaysTemplate()
        viewController.tabBarItem.title = tag.tabbarItemTitle
        
        return isRootViewController
            ? CommonNavigationController.rootViewController(viewController)
            : viewController
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
