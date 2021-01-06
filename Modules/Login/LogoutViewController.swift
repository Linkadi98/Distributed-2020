//
//  LogoutViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 08/12/2020.
//

import Foundation

class LogoutViewController: BaseViewController {
    
    @IBOutlet weak var infoContainerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var logoutButton: ColoredButton!
    
    private var currentAccount = AccountManager.shared.currentAccount
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tài khoản"
        
        view.backgroundColor = .grayBackground
        
        nameLabel.font = .defaultFont(ofSize: .medium)
        createDateLabel.font = .defaultFont(ofSize: .subtitle)
        
        nameLabel.textColor = .text
        createDateLabel.textColor = .grayText
        
        roleLabel.text = currentAccount?.role
        roleLabel.font = .defaultMediumFont(ofSize: .subtitle)
        roleLabel.textColor = .white
        
        roleLabel.textAlignment = .center
        
        roleLabel.autoSetDimension(.width, toSize: 60, relation: .greaterThanOrEqual)
        
        roleLabel.autoSetDimension(.height, toSize: 20)
        
        roleLabel.backgroundColor = .sapo
        roleLabel.layer.cornerRadius = 10
        roleLabel.layer.masksToBounds = true
        
        nameLabel.text = currentAccount?.name
        createDateLabel.text = currentAccount?.createdDate
        
        logoutButton.setTitleColor(.error, for: .normal)
        logoutButton.titleLabel?.font = .defaultFont(ofSize: .default)
    }
    
    @IBAction func logout(_ sender: Any) {
        AlertUtils.showCustomAlert(title: "Đăng xuất",
                                   message: "Bạn có chắc chắn muốn đăng xuất?",
                                   okTitle: "Đăng xuất",
                                   cancelTitle: "Thoát",
                                   okHandler: {
            
            AccountManager.shared.removeCurrentEmployee()
            
            AppDelegate.shared.replaceRootViewController(by: LoginViewController())
        }, from: self)
        
    }
}
