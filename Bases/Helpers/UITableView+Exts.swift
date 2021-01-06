//
//  UITableView+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import Foundation

extension UITableViewCell {
    @objc static var reuseId: String {
        return String(describing: self)
    }
    
    @objc static var nib: UINib {
        return UINib(nibName: String(describing: self),
                     bundle: nil)
    }
}


extension UITableView {
    func registerNib(for cellClass: UITableViewCell.Type) {
        registerNib(for: cellClass, reuseId: cellClass.reuseId)
    }
    
    func registerNib(for cellClass: UITableViewCell.Type, reuseId: String) {
        register(cellClass.nib, forCellReuseIdentifier: reuseId)
    }
    
    func registerClass(for cellClass: UITableViewCell.Type) {
        registerClass(for: cellClass, reuseId: cellClass.reuseId)
    }
    
    func registerClass(for cellClass: UITableViewCell.Type, reuseId: String) {
        register(cellClass, forCellReuseIdentifier: reuseId)
    }
    
    func registerClass(forHeaderFooter aClass: UITableViewHeaderFooterView.Type) {
        registerClass(forHeaderFooter: aClass, reuseId: aClass.reuseId)
    }
    
    func registerClass(forHeaderFooter aClass: UITableViewHeaderFooterView.Type, reuseId: String) {
        register(aClass, forHeaderFooterViewReuseIdentifier: reuseId)
    }
    
    func registerNibs<T: UITableViewCell>(for cellClasses: [T.Type]) {
        for cellClass in cellClasses {
            registerNib(for: cellClass)
        }
    }
}

extension UITableViewHeaderFooterView {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type,
                                                 withIdentifier identifier: String? = nil,
                                                 for indexPath: IndexPath) -> T {
        let reuseId = identifier ?? type.reuseId
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? T else {
            preconditionFailure("\(String(describing: self)) could not dequeue cell with identifier: \(reuseId)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type,
                                                                         withIdentifier identifier: String? = nil) -> T {
        let reuseId = identifier ?? type.reuseId
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: reuseId) as? T else {
            preconditionFailure("\(String(describing: self)) could not dequeue view with identifier: \(reuseId)")
        }
        return view
    }
}

extension UITableView {
    convenience init(frame: CGRect = .zero,
                     style: UITableView.Style = .plain,
                     dataSource: UITableViewDataSource?,
                     delegate: UITableViewDelegate?) {
        
        self.init(frame: frame, style: style)
        
        if let vc = dataSource as? BaseViewController {
            vc.scrollView = self
        }
        
        /// `commonSetup` sets `tableFooterView` to new value, it triggers dataSource methods
        /// and cause infinite loop if we reference tableView inside dataSource methods,
        /// so we have to set `dataSource` after `comonSetup`
        commonSetup()
        
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    /// Setup some common properties for table view
    @objc func commonSetup() {
        // Grouped table view doesn't need this to remove empty separator
        // Also if we set this in grouped tableview, section header and footer won't display properly
        if style == .plain {
            tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 1))
        }
        
        separatorColor = .line
        
        layer.borderColor = UIColor.line.cgColor
        layer.borderWidth = 0
        
        keyboardDismissMode = .interactive
        
        // Disable self-sizing row/header/footer on iOS 11
        if #available(iOS 11.0, *) {
            estimatedSectionHeaderHeight = 0
            estimatedSectionFooterHeight = 0
            estimatedRowHeight = 0
        }
    }
    
    func insertRows(_ rows: [Int], inSection section: Int, animated: Bool = true) {
        insertRows(at: rows.map { IndexPath(row: $0, section: section) }, with: animated ? .automatic : .none)
    }
    
    func deleteRow(_ row: Int, inSection section: Int, animated: Bool = true) {
        deleteRows(at: [IndexPath(row: row, section: section)], with: animated ? .automatic : .none)
    }
    
    func deleteRows(_ rows: [Int], inSection section: Int, animated: Bool = true) {
        deleteRows(at: rows.map { IndexPath(row: $0, section: section) }, with: animated ? .automatic : .none)
    }
    
    func reloadRow(_ row: Int, inSection section: Int, animated: Bool = true) {
        reloadRows(at: [IndexPath(row: row, section: section)], with: animated ? .automatic : .none)
    }
    
    func reloadRows(_ rows: [Int], inSection section: Int, animated: Bool = true) {
        reloadRows(at: rows.map { IndexPath(row: $0, section: section) }, with: animated ? .automatic : .none)
    }
    
    func reloadSection(_ section: Int, animated: Bool = true) {
        reloadSections(IndexSet(integer: section), with: animated ? .automatic : .none)
    }
    
    func batchUpdates(_ updates: (UITableView) -> Void, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                updates(self)
            }, completion: completion)
        } else {
            beginUpdates()
            updates(self)
            endUpdates()
        }
    }
    
    func alertRow(at indexPath: IndexPath) {
        scrollToRow(at: indexPath, at: .middle, animated: true)
        selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func alertSection(_ section: Int) {
        let numberOfRows = self.numberOfRows(inSection: section)
        let indexPaths = (0..<numberOfRows).map({ IndexPath(row: $0, section: section) })
        
        guard let firstIndexPath = indexPaths.first else {
            return
        }
        
        scrollToRow(at: firstIndexPath, at: .middle, animated: true)
        
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        guard let dataSource = dataSource else { return }
        
        var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1
        
        while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1, lastSectionWithAtLeasOneElements > 1 {
            lastSectionWithAtLeasOneElements -= 1
        }
        
        let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1
        
        guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }
        
        let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
        scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}
