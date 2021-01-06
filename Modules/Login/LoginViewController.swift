//
//  LoginViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation
import NVActivityIndicatorView
import DistributedAPI

final class LoginViewController: BaseViewController {
    
    private var containerView: UIView!
    private var appImageView: UIImageView!
    private var userTextField: UnderlineTextField!
    private var passwordTextField: UnderlineTextField!
    private var loginButton: ColoredButton!
    
    private lazy var indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                                       width: 32, height: 32),
                                                         type: .ballPulse,
                                                         color: .white)
    
    private var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configViewModel()
    }
    
    private func setupViews() {
        containerView = UIView(frame: .zero)
        appImageView = UIImageView(image: UIImage(named: "ic_login_drone"))
        userTextField = .init(frame: .zero)
        passwordTextField = .init(frame: .zero)
        loginButton = .init(frame: .zero)
        
        view.addSubviews(containerView, appImageView)
        containerView.addSubviews(userTextField, passwordTextField, loginButton)
        loginButton.addSubview(indicator)
        
        containerView.autoCenterInSuperview()
        containerView.autoPinEdge(.leading, to: .leading, of: view)
        containerView.autoPinEdge(.trailing, to: .trailing, of: view)
        
        appImageView.autoPinEdge(.leading, to: .leading, of: view)
        appImageView.autoPinEdge(.trailing, to: .trailing, of: view)
        appImageView.autoPinEdge(.top, to: .top, of: view)
        appImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        appImageView.autoPinEdge(.bottom, to: .top, of: containerView, withOffset: -40)
        
        userTextField.autoPinEdge(toSuperviewEdge: .top)
        passwordTextField.autoPinEdge(.top, to: .bottom, of: userTextField, withOffset: 16)
        
        loginButton.autoPinEdge(.top, to: .bottom, of: passwordTextField, withOffset: 20)
        
        userTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        userTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        passwordTextField.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        passwordTextField.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        
        loginButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        loginButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        loginButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
        
        userTextField.autoSetDimension(.height, toSize: 48)
        passwordTextField.autoSetDimension(.height, toSize: 48)
        loginButton.autoSetDimension(.height, toSize: 48)
        
        loginButton.setCornerRadius(to: 4)
        
        indicator.autoCenterInSuperview()
        indicator.isHidden = true
        
        loginButton.mainColor = .clear
        loginButton.backgroundColor = .sapo
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.titleLabel?.font = .defaultFont(ofSize: .default)
        
        userTextField.placeholder = "Tên đăng nhập"
        passwordTextField.placeholder = "Mật khẩu"
        
        userTextField.font = .defaultFont(ofSize: .medium)
        passwordTextField.font = .defaultFont(ofSize: .medium)
        
        let userImageView = UIImageView(image: UIImage(named: "ic-login-home"))
        let passwordImageView = UIImageView(image: UIImage(named: "ic-login-password"))
        
        userImageView.autoSetDimensions(to: .init(width: 25, height: 25))
        passwordImageView.autoSetDimensions(to: .init(width: 25, height: 25))
        
        userTextField.leftView = userImageView
        passwordTextField.leftView = passwordImageView
        
        passwordTextField.isPasswordEnabled = true
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        let userName = userTextField.text
        let password = passwordTextField.text
        viewModel.login(with: userName, password: password)
    }
    
    private func configViewModel() {
        viewModel.shouldShowIndicator = { [weak self] shouldShowIndicator in
            self?.indicator.isHidden = !shouldShowIndicator
            shouldShowIndicator ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
            
            self?.loginButton.setTitle(shouldShowIndicator
                                        ? ""
                                        : "Đăng nhập",
                                       for: .normal)
        }
    }
}

class LoginViewModel {
    
    var shouldShowIndicator: ((_ isAnimated: Bool) -> Void)?
    
    func login(with userName: String?, password: String?) {
        guard let userName = userName?.trim() else { return }
        
        guard let password = password?.trim() else { return }
        
        let data = LoginRequest(user: userName, password: password)
        shouldShowIndicator?(true)
        _ = Repository.shared.login(sendingData: data) { (r) in
            self.shouldShowIndicator?(false)
            switch r {
            case .success(let response):
                self.willMoveToApp(with: response.employee)
            case .failure(let error):
                AlertUtils.showError(error.errorMessage)
            }
        }
    }
    
    private func willMoveToApp(with emp: Employee?) {
        AccountManager.shared.save(emp)
        AppDelegate.shared.replaceRootViewController(by: CommonTabbarController())
    }
}
