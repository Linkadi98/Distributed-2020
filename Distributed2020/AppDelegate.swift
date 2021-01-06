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
    
    static var shared: AppDelegate = AppDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        prepareRootViewController()
        setupReachability()
        return true
    }
    
    private func getRootViewController() -> UIViewController? {
        return window?.rootViewController
    }
    
    private func prepareRootViewController() {
        if let loginController = getLoginController() {
            replaceRootViewController(by: loginController)
            return
        }
        
        let tabbarController = CommonTabbarController()
        replaceRootViewController(by: tabbarController)
    }
    
    func replaceRootViewController(by viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    private var reachability: Reachability?
    
    private func setupReachability() {
        reachability?.stopNotifier()
        reachability = Reachability(hostname: "google.com.vn")
        do {
            reachability?.whenUnreachable = { reachability in
                AlertUtils.showAlert(title: "Mất kết nối mạng", message: "Vui lòng kiểm tra kết nối mạng")
            }
            reachability?.whenReachable = {  _ in
                NotificationCenter.default.post(.init(name: .backOnline))
            }
            try reachability?.startNotifier()
        } catch {
            
        }
    }
    
    private func getLoginController() -> UIViewController? {
        if !AccountManager.shared.isLoggedIn {
            return LoginViewController()
        }
        
        return nil
    }
}

