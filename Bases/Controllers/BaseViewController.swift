//
//  BaseViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet internal var scrollView: UIScrollView? {
        didSet {
            scrollView?.alwaysBounceVertical = true
            scrollView?.keyboardDismissMode = .interactive
        }
    }
    
    internal var viewControllerTitle: String? {
        didSet {
            navigationItem.title = viewControllerTitle
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        predefineSettings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        predefineSettings()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(false)
        super.viewWillDisappear(animated)
    }
    
    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        navigationController?.show(vc, sender: sender)
    }
    
    private func predefineSettings() {
        edgesForExtendedLayout = .all
        automaticallyAdjustsScrollViewInsets = true
    }
    
    func scrollToTop() {
        if let scrollView = scrollView {
            let y = self.automaticallyAdjustsScrollViewInsets ? -self.topLayoutGuide.length : -scrollView.contentInset.top
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
    }
    
    @objc func internetDidBackOnline() {
        
    }
}
