//
//  AppDelegate.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        return window
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        prepareShowingTabbarController()
        setupReachability()
        return true
    }
    
    private func getRootViewController() -> UIViewController {
        let tabbarController = CommonTabbarController()
        
        return tabbarController
    }
    
    private func prepareShowingTabbarController() {
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
    }
    
    private var presentingViewController: UIViewController? {
        getRootViewController().presentingViewController
    }
    
    private var reachability: Reachability?
    
    private func setupReachability() {
        reachability?.stopNotifier()
        reachability = Reachability(hostname: "google.com.vn")
        do {
            reachability?.whenUnreachable = { [weak self] reachability in
                AlertUtils.showAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
            }
            reachability?.whenReachable = { [weak self] _ in
                
            }
            try reachability?.startNotifier()
        } catch {
            
        }
    }
}

