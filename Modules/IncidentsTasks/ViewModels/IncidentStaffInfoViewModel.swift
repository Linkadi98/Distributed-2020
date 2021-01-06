//
//  IncidentStaffInfoViewModel.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import Foundation
import DistributedAPI

class IncidentStaffInfoViewModel {
    
    enum ButtonAction {
        case processTask
        case reportTask
        
        var title: String {
            switch self {
            case .processTask:
                return "Bắt đầu xử lý"
            case .reportTask:
                return "Báo cáo công việc"
            }
        }
    }
    
    private var employeeDetail: Employee? = AccountManager.shared.currentAccount?.employee
    private var pendingTasks: [Task]?
    private var currentTask: Task?
    private var isCurrentTaskActivated: Bool = false
    
    private var currentAction: ButtonAction {
        if !isCurrentTaskActivated {
            return .processTask
        } else {
            return .reportTask
        }
    }
    
    private(set) var isCaptain: Bool = false
    
    var employeeName: String {
        employeeDetail?.fullName ?? "---"
    }
    
    var currentTaskStatus: String {
        currentTask?.statusText ?? "---"
    }
    
    var currentTaskName: String {
        currentTask?.taskType?.name ?? "---"
    }
    
    var numberOfPendingTasksText: String {
        "\(pendingTasks?.count ?? 0) task đang chờ xử lý"
    }
    
    var employeeType: String {
        return isCaptain ? "Đội trưởng" : "Nhân viên"
    }
    
    var projectType: String {
        employeeDetail?.projectType ?? "---"
    }
    
    var currentTaskDescText: String {
        currentTask?.taskType?.description ?? "Không có"
    }
    
    var shouldShowButton: Bool {
        currentTask != nil
    }
    
    var reloadViews: (() -> Void)?
    var updateButtonTitle: ((_ title: String) -> Void)?
    var openReportTaskController: ((_ id: Int?) -> Void)?
    var showLoading: ((_ message: String) -> Void)?
    var hideLoading: (() -> Void)?
    
    func getData(needLoading: Bool = true) {
        if needLoading {
            showLoading?("Vui lòng đợi..")
        }
        
        Repository.shared.getEmployeeDetail { (r) in
            self.hideLoading?()
            switch r {
            case.success(let response):
                self.currentTask = response.currentTask
                self.isCurrentTaskActivated = response.activeCurrentTask ?? false
                self.pendingTasks = response.pendingTasks
                self.reloadViews?()
                self.updateButtonTitle?(self.currentAction.title)
            case .failure(let error):
                AlertUtils.showError(error.errorMessage)
            }
        }
    }
    
    func performAction() {
        updateButtonTitle?(currentAction.title)
        switch currentAction {
        case .processTask:
//            openReportTaskController?(currentTask?.id)
            processTask()
        case .reportTask:
            openReportTaskController?(currentTask?.id)
        }
    }
    
    private func processTask() {
        showLoading?("Vui lòng đợi..")
        Repository.shared.activeCurrentTask(id: currentTask?.id ?? 0, completion: { r in
            self.hideLoading?()
            switch r {
            case .success:
                AlertUtils.showSuccess("Xác nhận bắt đầu xử lý thành công!")
                self.isCurrentTaskActivated = true
                self.updateButtonTitle?(self.currentAction.title)
                self.getData(needLoading: false)
            case .failure(let error):
                AlertUtils.showError(error.errorMessage)
            }
        })
    }
}
