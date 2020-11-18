//
//  AlertUtils.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

class AlertUtils {
    
    @discardableResult
    static func showCustomAlert(title: String,
                                message: String,
                                okTitle: String,
                                cancelTitle: String? = nil,
                                okHandler: (() -> Void)? = nil,
                                cancelHandler: (() -> Void)? = nil,
                                from viewController: UIViewController? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle,
                                     style: .default,
                                     handler: { _ in okHandler?() })
        alertController.addAction(okAction)
        
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle,
                                             style: .cancel,
                                             handler: { _ in cancelHandler?() })
            alertController.addAction(cancelAction)
        }
        
        if let viewController = viewController {
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(alertController, animated: true, completion: nil)
        }
        
        return alertController
    }
    
    @discardableResult
    static func showAlert(title: String,
                          message: String,
                          handler: (() -> Void)? = nil,
                          from viewController: UIViewController? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý",
                                     style: .cancel) { _ in handler?() }
        alertController.addAction(okAction)
        
        if let viewController = viewController {
            viewController.present(alertController, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(alertController, animated: true, completion: nil)
        }
        
        return alertController
    }
}
