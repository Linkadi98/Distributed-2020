//
//  BaseListViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit
import EmptyDataSet_Swift
import UIScrollView_InfiniteScroll
import NVActivityIndicatorView
import DistributedAPI

class BaseListViewController<T>: BaseViewController {
    
    private let DEFAULT_REFRESHING_INDICATOR_SIZE: CGFloat = 40.0
    private let DEFAULT_LOAD_MORE_INDICATOR_SIZE: CGFloat = 32.0
    
    var tableView: UITableView!
    
    var list: [T] = []
    
    var searchTitleView: SearchTitleView!
    
    var searchField: UITextField!
    
    var emptyDataViewSetting: EmptyDataViewSettings?
    
    var shouldShowInfiniteLoading: Bool = false
    
    var customTitleView: UIView?
    
    var tableViewEmtpyAttributedString: NSAttributedString?
    var tableViewEmtpyDescriptionAttributedString: NSAttributedString?
    var tableViewEmtpySearchResultAttributedString: NSAttributedString?
    
    var leftBarButtons: [UIBarButtonItem]?
    var rightBarButtons: [UIBarButtonItem]?
    
    var refreshIndicator: UIRefreshControl!
    
    var searchPlaceHolder: String? {
        didSet {
            searchTitleView.searchField.placeholder = searchPlaceHolder ?? "Tìm kiếm"
        }
    }
    
    lazy var loadingIndicator: NVActivityIndicatorView = .init(frame: CGRect(x: 0, y: 0,
                                                                             width: DEFAULT_REFRESHING_INDICATOR_SIZE,
                                                                             height: DEFAULT_REFRESHING_INDICATOR_SIZE),
                                                               type: .ballBeat, color: .sapo, padding: 0)
    
    lazy var infiniteLoadingIndicator: NVActivityIndicatorView = .init(frame: CGRect(x: 0, y: 0,
                                                                                   width: DEFAULT_LOAD_MORE_INDICATOR_SIZE,
                                                                                   height: DEFAULT_LOAD_MORE_INDICATOR_SIZE),
                                                                     type: .ballBeat, color: .sapo, padding: 0)
    
    var page: Int = 1 {
        didSet {
            if page == 1 {
                shouldShowInfiniteLoading = false
            } else {
                shouldShowInfiniteLoading = true
            }
        }
    }
    
    var isRefreshing: Bool = true {
        didSet {
            if isRefreshing {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
            
            tableView.reloadEmptyDataSet()
        }
    }
    
    var searchText: String? {
        return searchField?.text
    }
    
    var isSearching: Bool {
        return !(searchText?.isEmpty ?? true)
    }
    
    var shouldDisplayEmptyDataSet: Bool {
        !isRefreshing && !isSearching
    }
    
    var shouldDisplaySearchEmptyText: Bool {
        !isRefreshing && isSearching
    }
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(loadingIndicator)
        view.backgroundColor = .white
        loadingIndicator.autoCenterInSuperview()
        loadingIndicator.isHidden = false
        
        customTitleView = navigationItem.titleView
        buildSearchView()
        
        refreshIndicator = .init()
        tableView.addSubview(refreshIndicator)
        refreshIndicator.addTarget(self, action: #selector(refreshControlDidChange), for: .valueChanged)
    }
    
    private func setupTableView() {
        if tableView == nil {
            tableView = UITableView(frame: .zero, style: .plain)
            tableView.tableFooterView = UIView()
            view.addSubview(tableView)
            tableView.autoPinEdgesToSuperviewEdges()
        }
        
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        tableView.backgroundColor = .white
        
        if let settings = emptyDataViewSetting {
            tableView.emptyDataSetView { (emptyView) in
                emptyView.titleLabelString(settings.titleAttributedString)
                    .detailLabelString(settings.detailAttributedString)
                    .image(settings.image)
                    .buttonTitle(settings.buttonTitleForNormalState, for: .normal)
                    .dataSetBackgroundColor(settings.dataSetBackgroundColor)
                    .shouldDisplay(self.shouldDisplayEmptyDataSet)
                    .isTouchAllowed(settings.isTouchAllowed)
                    .isScrollAllowed(settings.isScrollAllowed)
            }
        } else {
            tableView.emptyDataSetSource = self as? EmptyDataSetSource
            tableView.emptyDataSetDelegate = self as? EmptyDataSetDelegate
        }
        
        tableView.infiniteScrollIndicatorView = infiniteLoadingIndicator
        
        tableView.addInfiniteScroll { [weak self] (_) in
            self?.handleInfiniteLoading()
        }
        
        tableView.setShouldShowInfiniteScrollHandler { [weak self] (_) -> Bool in
            return self?.shouldShowInfiniteLoading ?? true
        }
        
        tableView.finishInfiniteScroll { [weak self] (_) in
            self?.handleFinishInfiniteLoading()
        }
    }
    
    internal func handleInfiniteLoading() {
        
    }
    
    internal func handleFinishInfiniteLoading() {
        
    }
    
    internal func clearList() {
        list.removeAll()
    }
    
    private func buildSearchView() {
        searchTitleView = SearchTitleView(frame: CGRect(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: 44))
        searchTitleView.onTextChangedAction = { [weak self] _ in
            self?.searchTextDidChange(self?.searchField)
        }
        searchTitleView.cancelSearchAction = { [weak self] in
            self?.searchField.text?.removeAll()
            self?.refreshList()
            self?.hideSearchView()
        }
        
        let searchItem = UIBarButtonItem(image: UIImage(named: "ic_search_bar_button")?.alwaysTemplate(),
                                         style: .plain,
                                         target: self,
                                         action: #selector(showSearchView))
        navigationItem.rightBarButtonItems = [ searchItem ]
        navigationItem.rightBarButtonItem?.tintColor = .icon
        
        self.searchField = searchTitleView?.searchField
    }
    
    private func searchTextDidChange(_ searchField: UITextField?) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(searchingTimeDidFire),
                                     userInfo: nil, repeats: false)
        refreshList()
    }
    
    @objc internal func searchingTimeDidFire() {
        
    }
    
    @objc private func refreshControlDidChange() {
        refreshIndicator.endRefreshing()
        
        if !isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.refreshList()
            }
        }
    }
    
    internal func refreshList() {
        page = 1
        clearList()
        tableView.reloadData()
        isRefreshing = true
    }
    
    internal func updatePage(from metadata: MetadataModel?) {
        if list.count < (metadata?.total ?? 0) {
            page = (metadata?.page ?? page) + 1
        } else {
            page = -1
        }
    }
    
    private func hideSearchView() {
        updateSearchVisibility(visible: false)
    }
    
    @objc private func showSearchView() {
        updateSearchVisibility(visible: true)
    }
    
    private func updateSearchVisibility(visible: Bool,
                                        animated: Bool = true,
                                        autoFocus: Bool = true) {
        if visible {
            navigationController?.navigationBar.isAccessibilityElement = false
            navigationItem.isAccessibilityElement = false
            
            saveAndRemoveBarButtons()
            
            func focusSearchFieldIfNeeded() {
                if autoFocus {
                    searchField.becomeFirstResponder()
                }
            }
            
            if !animated {
                focusSearchFieldIfNeeded()
            } else {
                searchTitleView.animateFadeIn(withDuration: 0.15) { _ in
                    focusSearchFieldIfNeeded()
                }
            }
            
            navigationItem.titleView = searchTitleView
            navigationItem.titleView?.isAccessibilityElement = false
            
            return
        }
        
        if searchField.isFirstResponder {
            searchField.resignFirstResponder()
        }
        
        if !animated {
            restoreBarButtons()
        } else {
            searchTitleView.animateFadeOut(withDuration: 0.15) { _ in
                self.restoreBarButtons()
            }
        }
    }
    
    private func saveAndRemoveBarButtons() {
        leftBarButtons = navigationItem.leftBarButtonItems
        rightBarButtons = navigationItem.rightBarButtonItems
        navigationItem.setLeftBarButtonItems(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
        
        customTitleView = navigationItem.titleView
    }
    
    private func restoreBarButtons() {
        navigationItem.titleView = customTitleView
        
        if let lefts = leftBarButtons {
            navigationItem.setLeftBarButtonItems(lefts, animated: true)
        }
        
        if let rights = rightBarButtons {
            navigationItem.setRightBarButtonItems(rights, animated: true)
        }
    }
    
    // MARK: - Empty Data Set
    @objc func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return list.count > 0
    }

    @objc func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return !isRefreshing
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
       refreshList()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        if shouldDisplayEmptyDataSet {
            return tableViewEmtpyAttributedString
        }
        
        if shouldDisplaySearchEmptyText {
            return tableViewEmtpySearchResultAttributedString
        }
        
        return nil
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        if shouldDisplayEmptyDataSet {
            return nil
        }
        
        if shouldDisplaySearchEmptyText {
            return UIImage(named: "ic_search")?.alwaysTemplate()
        }
        
        return nil
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return .text
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if shouldDisplayEmptyDataSet {
            return tableViewEmtpyDescriptionAttributedString
        }
        
        return nil
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        .white
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
}

class SearchTitleView: UIView {
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    private(set) var searchField: UITextField!
    private(set) var cancelButton: UIButton!
    
    var cancelSearchAction: (() -> Void)?
    var onTextChangedAction: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        addSubview(stackView)
        
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        let searchField = NoBorderWithPaddingTextField(frame: .zero)
        searchField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchField.layer.cornerRadius = 4
        searchField.backgroundColor = UIColor(hex: "#F6F7FB")
        searchField.font = .defaultFont(ofSize: .default)
        searchField.addTarget(self, action: #selector(searchTextDidChanged(_:)), for: .editingChanged)
        searchField.clearButtonMode = .whileEditing
        
        searchField.accessibilityIdentifier = "Search"
        searchField.accessibilityLabel = "Search"
        searchField.accessibilityTraits = .searchField
        
        let cancelButton = UIButton(type: .system)
        cancelButton.titleLabel?.font = .defaultFont(ofSize: .title)
        cancelButton.setTitle("Huỷ", for: .normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        cancelButton.accessibilityIdentifier = "CancelSearch"
        cancelButton.accessibilityLabel = "CancelButton"
        cancelButton.accessibilityTraits = .button
        
        isAccessibilityElement = false
        accessibilityIdentifier = "SearchView"
        accessibilityTraits = .searchField
        
        stackView.addArrangedSubview(searchField)
        stackView.addArrangedSubview(cancelButton)
        stackView.subviews.forEach {
            $0.isAccessibilityElement = true
        }
        
        shouldGroupAccessibilityChildren = true
        
        searchField.autoSetDimension(.height, toSize: 32)
        
        cancelButton.autoSetDimension(.height, toSize: 28)
        
        self.searchField = searchField
        self.cancelButton = cancelButton
    }
    
    @objc private func searchTextDidChanged(_ textField: UITextField) {
        onTextChangedAction?(textField.text)
    }
    
    @objc private func didTapCancelButton() {
        cancelSearchAction?()
    }
}
