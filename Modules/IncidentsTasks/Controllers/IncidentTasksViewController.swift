//
//  IncidentTasksViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import EmptyDataSet_Swift

class IncidentTasksViewController: BaseListViewController<Any>, EmptyDataSetSource, EmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerTitle = "Sự cố được gán"
        searchPlaceHolder = "Tìm kiếm sự cố"
        
        isRefreshing = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
