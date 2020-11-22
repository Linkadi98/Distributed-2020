//
//  IncidentTasksViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import EmptyDataSet_Swift
import DistributedAPI

class IncidentTasksViewController: BaseListViewController<Task>, EmptyDataSetSource, EmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModel: IncidentTasksViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerTitle = "Danh sách công việc"
        searchPlaceHolder = "Tìm kiếm sự cố"
        
        configViewModel()
        
        tableViewEmtpyAttributedString = "Chưa có dữ liệu".attributedMaker
            .font(.defaultMediumFont(ofSize: .custom(18)))
            .color(.text)
            .build()
        
        tableViewEmtpyDescriptionAttributedString = "Vui lòng kiểm tra lại".attributedMaker
            .font(.defaultFont(ofSize: .medium))
            .color(.grayText)
            .build()
        
        tableViewEmtpySearchResultAttributedString = "Không có kết quả tìm kiếm".attributedMaker
            .font(.defaultMediumFont(ofSize: .custom(18)))
            .color(.text)
            .build()
        
        isRefreshing = true
        
        viewModel.getData(page: page, searchText: searchText)
    }
    
    override func handleInfiniteLoading() {
        viewModel.getData(page: page, searchText: searchText)
    }
    
    override func handleFinishInfiniteLoading() {
        isRefreshing = false
        tableView.reloadData()
    }
    
    override func searchingTimeDidFire() {
        viewModel.getData(page: page, searchText: searchText)
    }
    
    override func refreshList() {
        super.refreshList()
        viewModel.getData(page: page, searchText: searchText)
    }
    
    private func configViewModel() {
        viewModel.updateTasks = { [weak self] tasks in
            self?.isRefreshing = false
            if self?.page == 1 {
                self?.list = tasks
            } else {
                self?.list.append(contentsOf: tasks)
            }
            
            self?.tableView.reloadData()
        }
        
        viewModel.updateMetadata = { [weak self] metadata in
            self?.updatePage(from: metadata)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

class IncidentTasksViewModel {
    
    var updateTasks: (([Task]) -> Void)?
    var updateMetadata: ((MetadataModel) -> Void)?
    func getData(page: Int, searchText: String?) {
        var params = TaskHandlerParams()
        params.id = 11111
        params.page = page
        params.limit = PageSize.medium.value
        
        Repository.shared.getAllTasks(params: params, completion: {
            if let response = try? $0.get(), let tasks = response.tasks, let metadata = response.metadata {
                self.updateTasks?(tasks)
                self.updateMetadata?(metadata)
            } else {
                self.updateTasks?([])
            }
        })
    }
}
