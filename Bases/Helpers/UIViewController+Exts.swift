//
//  UIViewController+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

extension UIViewController {
    enum BarButtonItemPosition {
        case left
        case right
    }
    
    @discardableResult
    func addCancelBarButtonItem(target: Any? = self,
                                action: Selector? = #selector(dismissAnimated)) -> UIBarButtonItem {
        return addBarButtonItem(image: #imageLiteral(resourceName: "CloseIcon"),
                                position: .left,
                                target: target,
                                action: action)
    }
    
    @discardableResult
    func addDoneBarButtonItem(target: Any?, action: Selector?) -> UIBarButtonItem {
        return addBarButtonItem(image: #imageLiteral(resourceName: "DoneIcon"),
                                position: .right,
                                target: target,
                                action: action)
    }
    
    @discardableResult
    func addBarButtonItem(image: UIImage?,
                          position: BarButtonItemPosition,
                          target: Any?,
                          action: Selector?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: image,
                                            style: .plain,
                                            target: target,
                                            action: action)
        
        switch position {
        case .left:
            self.navigationItem.leftBarButtonItem = barButtonItem
        case .right:
            self.navigationItem.rightBarButtonItem = barButtonItem
        }
        
        return barButtonItem
    }
    
    @IBAction func dismissAnimated() {
        dismiss(animated: true)
    }
    
    @IBAction func popAnimated() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func selfDismiss(_ sender: Any?) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selfDismiss() {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selfPop() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func popToSelf() {
        navigationController?.popToViewController(self, animated: true)
    }
    
    @objc func popToPrevious() {
        guard let nav = navigationController else { return }
        
        let numberOfVCs = nav.viewControllers.count
        if numberOfVCs < 2 {
            return
        }
        
        let prev = nav.viewControllers[numberOfVCs - 2]
        nav.popToViewController(prev, animated: true)
    }
    
    func presentAttachedToNavigationController(_ vc: UIViewController,
                                               modalPresentationStyle: UIModalPresentationStyle? = nil,
                                               completion: (() -> Void)? = nil) {
        if vc is UINavigationController {
            present(vc, animated: true, completion: nil)
            return
        }
        
        let navigationController = CommonNavigationController(rootViewController: vc)
        let modalStyle: UIModalPresentationStyle
        if #available(iOS 13.0, *) {
            modalStyle = UIDevice.isPad ? .automatic : .fullScreen
        } else {
            modalStyle = UIDevice.isPad ? .formSheet : .fullScreen
        }
        navigationController.modalPresentationStyle = modalStyle
        if #available(iOS 13.0, *) {
            navigationController.isModalInPresentation = true
        }
        present(navigationController, animated: true, completion: completion)
    }
    
    func presentFullscreen(_ vc: UIViewController,
                           animated: Bool = true,
                           completion: (() -> Void)? = nil) {
        present(vc: vc, animated: animated, completion: completion)
    }
    
    func present(vc: UIViewController,
                 style: UIModalPresentationStyle = .fullScreen,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle = style
        present(vc, animated: animated, completion: completion)
    }
}
