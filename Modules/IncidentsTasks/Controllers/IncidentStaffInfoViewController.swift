//
//  IncidentStaffInfoViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 30/11/2020.
//

import Foundation
import DistributedAPI
import SwiftMessages
import JGProgressHUD

class IncidentStaffInfoViewController: BaseViewController {
    
    @IBOutlet weak var staffInfoTitleLabel: UILabel!
    @IBOutlet weak var staffName: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var roleView: UIView!
    
    @IBOutlet weak var taskButton: UIButton!
    
    @IBOutlet weak var currentTaskTitleLabel: UILabel!
    @IBOutlet weak var currentTaskNameLabel: UILabel!
    @IBOutlet weak var taskTypeTitleLabel: UILabel!
    
    @IBOutlet weak var currentTaskDesc: UILabel!
    @IBOutlet weak var priorityTitleLabel: UILabel!
    @IBOutlet weak var statusTitleLabel: UILabel!
    
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var currentTaskStatusLabel: UILabel!
    
    @IBOutlet weak var activeButton: ColoredButton!
    
    private var loadingView: JGProgressHUD?
    
    private var viewModel: IncidentStaffInfoViewModel!
    
    private lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView?.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh), for: .valueChanged)
        
        [ staffInfoTitleLabel, currentTaskTitleLabel].forEach {
            $0?.font = .defaultMediumFont(ofSize: .default)
            $0?.textColor = .text
        }
        
        [ staffName,
          currentTaskNameLabel,
          taskTypeTitleLabel,
          priorityTitleLabel,
          statusTitleLabel,
          currentTaskStatusLabel
        ].forEach {
            $0?.textColor = .text
            $0?.font = .defaultFont(ofSize: .default)
        }
        
        currentTaskDesc.font = .defaultFont(ofSize: .medium)
        currentTaskDesc.textColor = .grayText
        
        roleView.layer.cornerRadius = 10
        roleView.backgroundColor = .grayButtonBackground
        
        roleLabel.textColor = .white
        roleLabel.font = .defaultFont(ofSize: .mediumSmall)
          
        typeLabel.textColor = .gray
        typeLabel.font = .defaultFont(ofSize: .subtitle)
        
        activeButton.cornerRadius = 4
        activeButton.setTitleColor(.white, for: .normal)
        activeButton.backgroundColor = .sapo
        
        taskButton.titleLabel?.font = .defaultFont(ofSize: .medium)
        taskButton.setTitleColor(.sapo, for: .normal)
        
        activeButton.setTitle("", for: .normal)
        
        view.backgroundColor = .grayBackground
        navigationItem.title = "Chi tiết công việc"
        
        activeButton.addTarget(self, action: #selector(onTouchUpInsideButton), for: .touchUpInside)
        taskButton.addTarget(self, action: #selector(onTouchTaskButton), for: .touchUpInside)
        registerNotification()
        viewModel = .init()
        configViewModel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            self?.viewModel.getData()
        }
        
    }
    
    override func internetDidBackOnline() {
        super.internetDidBackOnline()
//        viewModel.getData()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(internetDidBackOnline), name: .backOnline, object: nil)
    }
    
    @objc private func refreshControlDidRefresh() {
        refreshControl.endRefreshing()
        viewModel.getData()
    }
    
    private func configViewModel() {
        viewModel.reloadViews = { [weak self] in
            guard let self = self, let vm = self.viewModel else { return }
            
            self.staffName.text = vm.employeeName
            self.taskButton.setTitle(vm.numberOfPendingTasksText, for: .normal)
            self.typeLabel.text = vm.projectType
            self.currentTaskDesc.text = vm.currentTaskDescText
            self.currentTaskStatusLabel.text = vm.currentTaskStatus
            self.currentTaskNameLabel.text = vm.currentTaskName
            self.roleView.backgroundColor = vm.isCaptain ? .error : .sapo
            self.roleLabel.text = vm.employeeType
            self.activeButton.isHidden = !vm.shouldShowButton
        }
        
        viewModel.updateButtonTitle = { [unowned self] title in
            self.activeButton.setTitle(title, for: .normal)
        }
        
        viewModel.openReportTaskController = { [unowned self] id in
            guard let id = id else {
                return 
            }
            let vc = ReportTaskViewController(with: .init(id: id))
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.showLoading = { [unowned self] message in
            self.loadingView = AlertUtils.showLoading(title: message, in: self.view)
        }
        
        viewModel.hideLoading = { [unowned self] in
            self.loadingView?.dismiss()
        }
    }
    
    @objc private func onTouchTaskButton() {
        let vc = IncidentTasksViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onTouchUpInsideButton() {
        viewModel.performAction()
    }
}
