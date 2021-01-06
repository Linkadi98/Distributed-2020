//
//  AlertUtils.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit
import SwiftMessages
import NVActivityIndicatorView
import SCLAlertView
import SwiftEntryKit
import JGProgressHUD
import DistributedAPI

class AlertUtils {
    
    static let dropDownPresenter: SwiftMessages = {
        let presenter = SwiftMessages.sharedInstance
        presenter.pauseBetweenMessages = 0
        return presenter
    }()
    
    private let messagePresenter = SwiftMessages()
    
    private static let successAlertDuration: TimeInterval = 1.5
    
    private static let errorAlertDuration: TimeInterval = 3
    
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
                                     style: .destructive,
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
    
    static func showError(_ message: String) {
        showDropdownMessage(message,
                            duration: errorAlertDuration,
                            color: .error,
                            textColor: .white,
                            iconImage: UIImage(named: "ic_dropdown_alert_error"))
    }
    
    static func showSuccess(_ message: String) {
        showDropdownMessage(message,
                            duration: successAlertDuration,
                            color: .successAlert,
                            textColor: .white,
                            iconImage: UIImage(named: "ic_dropdown_alert_success"))
    }
    
    @discardableResult
    static func showLoading(title: String? = nil, subTitle: String? = nil, in view: UIView) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = title
        hud.detailTextLabel.text = subTitle
        hud.interactionType = .blockAllTouches
        hud.position = .center
        hud.show(in: view, animated: true)
        
        hud.dismiss(afterDelay: .init(30))
        
        return hud
    }
    
    /// source from Kien Nguyen - Sapo JSC
    static func showDropdownMessage(_ message: String,
                                    description: String? = nil,
                                    duration: TimeInterval = 0,
                                    color: UIColor? = nil,
                                    textColor: UIColor = .white,
                                    iconImage: UIImage? = nil) {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .messageView)
        
        if let iconImage = iconImage {
            view.configureContent(title: message,
                                  body: description ?? "",
                                  iconImage: iconImage)
        } else {
            view.configureContent(title: message,
                                  body: description ?? "")
        }
        
        view.backgroundView.backgroundColor = color
        view.titleLabel?.textColor = textColor
        view.bodyLabel?.textColor = textColor
        
        view.titleLabel?.font = .defaultFont(ofSize: .custom(18))
        view.titleLabel?.numberOfLines = 0
        view.titleLabel?.textAlignment = .center
        
        view.bodyLabel?.font = .defaultFont(ofSize: .custom(16))
        view.bodyLabel?.isHidden = description?.isEmpty ?? true
        
        // Ugly fix for titleLabel's alignment to work, until the library supports this
        // https://github.com/SwiftKickMobile/SwiftMessages/issues/355
        if let stackView = view.titleLabel?.superview as? UIStackView {
            stackView.alignment = .fill
        }
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.5
        view.layer.masksToBounds = false
        
        view.button?.isHidden = true
        
        //FIXME:
        if #available(iOS 11.0, tvOS 11.0, *) {
            let top = AppDelegate.shared.window?.safeAreaInsets.top ?? 0
            if top > 20 {
                view.layoutMarginAdditions = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            } else {
                view.layoutMarginAdditions = UIEdgeInsets(top: 32, left: 16, bottom: 12, right: 16)
            }
        } else {
            view.layoutMarginAdditions = UIEdgeInsets(top: 32, left: 16, bottom: 12, right: 16)
        }
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .alert)
        config.duration = duration == 0 ? .forever : .seconds(seconds: duration)
        config.dimMode = .none
        config.shouldAutorotate = true
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent
        
        dropDownPresenter.hide(animated: false)
        
        DispatchQueue.main.async {
            self.dropDownPresenter.show(config: config, view: view)
        }
    }
    
    static func showLoadingView(message: String = "Vui lòng đợi..", duration: TimeInterval) {
        
    }
    
    static func showDropdownMessageView(message: String, duration: TimeInterval, in controller: UIViewController) {
//        var attributes = EKAttributes()
//        attributes.displayMode = .inferred
//        attributes.displayDuration = duration
//        attributes.position = .top
//        attributes.popBehavior = .animated(animation: .translation)
//        attributes.exitAnimation = .init(translate: .init(duration: 2), scale: .none, fade: .none)
//        attributes.entryBackground = .visualEffect(style: .standard)
//        attributes.screenInteraction = .absorbTouches
//        attributes.precedence = .enqueue(priority: .max)
//        attributes.shadow = .active(with: .init(opacity: 0.12, radius: 4))
//        attributes.entranceAnimation = .translation
//        attributes.windowLevel = .normal
//
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
//        customView.backgroundColor = .red
        
        // Create a basic toast that appears at the top
        var attributes = EKAttributes.topToast
        
        // Set its background to white
        attributes.entryBackground = .color(color: .white)
        
        // Animate in and out using default translation
        attributes.entranceAnimation = .translation
        attributes.exitAnimation = .translation
        
//        let customView = UIView()
        /*
         ... Customize the view as you like ...
         */
        
        // Display the view with the configuration
        SwiftEntryKit.display(entry: customView, using: attributes)
        
//        SwiftEntryKit.display(entry: customView, using: attributes, presentInsideKeyWindow: true)
    }
}
