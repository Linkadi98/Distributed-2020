//
//  ReportTaskViewController.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import Foundation
import UIKit
import AssetsPickerViewController
import Photos
import DistributedAPI
import JGProgressHUD

class ReportTaskViewController: BaseViewController {
    
    @IBOutlet weak var titleTextField: MPFloatLabeledSelectableTextField!
    @IBOutlet weak var contentTextField: MPFloatLabeledSelectableTextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var sendReportButton: ColoredButton!
    
    private var viewModel: ReportTaskViewModel
    
    private var loadingView: JGProgressHUD?
    
    init(with viewModel: ReportTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllerTitle = "Báo cáo công việc"
        
        sendReportButton.mainColor = .clear
        sendReportButton.backgroundColor = .sapo
        sendReportButton.cornerRadius = 4
        sendReportButton.setTitle("Gửi báo cáo", for: .normal)
        sendReportButton.setTitleColor(.white, for: .normal)
        sendReportButton.titleLabel?.font = .defaultFont(ofSize: .default)
        
        configImageCollectionView()

        configViewModel()
        
        sendReportButton.addTarget(self, action: #selector(sendReport), for: .touchUpInside)
    }
    
    @objc private func sendReport() {
        viewModel.sendReportInfo(title: titleTextField.text, content: contentTextField.text)
    }
    
    private func configViewModel() {
        viewModel.reloadImageCollectionView = { [unowned self] in
            self.imageCollectionView.reloadData()
        }
        
        viewModel.shouldShowLoadingView = { [unowned self] shouldShowLoading in
            if shouldShowLoading {
                self.loadingView = AlertUtils.showLoading(title: "Vui lòng đợi", in: self.view)
            } else {
                self.loadingView?.dismiss()
            }
        }
    }
    
    private func configImageCollectionView() {
        imageCollectionView.registerCell(type: ImageCollectionViewCell.self)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 4
            layout.minimumInteritemSpacing = 4
            
            layout.itemSize = .init(width: 64, height: 64)
        }
    }
}

extension ReportTaskViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: ImageCollectionViewCell.self, for: indexPath)
        
        if indexPath.row == 0 {
            cell.updateImageView(.imagePicker)
        } else if let image = viewModel.image(at: indexPath.row)?.imageType {
            cell.updateImageView(image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            openImageAssetController()
        }
    }
    
    private func openImageAssetController() {
        let vc = AssetsPickerViewController()
        vc.pickerDelegate = self
        vc.pickerConfig.selectedAssets = viewModel.selectedAssets
        vc.pickerConfig.assetsMinimumSelectionCount = 0
        vc.pickerConfig.assetIsShowCameraButton = false
        presentAttachedToNavigationController(vc)
    }
}

extension ReportTaskViewController: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        
    }
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        if assets.count > 1 {
            AlertUtils.showError("Hiện tại hệ thống chỉ hỗ trợ gửi 1 ảnh")
            return
        }
        
        viewModel.addPhotos(from: assets)
        view.endEditing(true)
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {}
    
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {
    }
}

struct ReportImage {
    
    private var asset: PHAsset
    
    var imageType: ImageType {
        .normal(image: asset.toImage(size: .thumb))
    }
    
    var imageData: Data? {
        asset.toImage(size: .grande).png()
    }
    
    var imageFileName: String? {
        asset.originalFilename
    }
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}

class ReportTaskViewModel {
    private var id: Int
    private var images: [ReportImage] = []
    
    private(set) var selectedAssets: [PHAsset] = []
    
    var numberOfItems: Int {
        images.count + 1
    }
    
    var hasImagesSelected: Bool {
        images.count != 0
    }
    
    var reloadImageCollectionView: (() -> Void)?
    var shouldShowLoadingView: ((Bool) -> Void)?
    
    init(id: Int) {
        self.id = id
    }
    
    func addPhotos(from assets: [PHAsset]) {
        images.removeAll()
        selectedAssets.removeAll()
        
        selectedAssets = assets
        
        for asset in assets {
            images.append(.init(asset: asset))
        }
        
        reloadImageCollectionView?()
    }
    
    func removePhoto(at index: Int) {
        images.remove(at: index)
        reloadImageCollectionView?()
    }
    
    func image(at index: Int) -> ReportImage? {
        images[index - 1]
    }
    
    func sendReportInfo(title: String?, content: String?) {
        guard let title = title, let content = content, !title.trim().isEmpty, !content.trim().isEmpty else {
            AlertUtils.showError("Bạn cần điền đủ thông tin báo cáo")
            return
        }
        guard hasImagesSelected else {
            AlertUtils.showError("Bạn phải chọn ít nhất 1 tấm ảnh để gửi báo cáo")
            return
        }
        
        shouldShowLoadingView?(true)
        
        var data = ReportData(id: id, title: title, content: content)
        let first = images.first
        data.image = first?.imageData
        data.imageFileName = first?.imageFileName
        
        if let count = data.image?.count, count > Consts.maxApiImageSize {
            shouldShowLoadingView?(false)
            return
        }
        
        Repository.shared.sendReportInfo(data: data, comletion: {
            self.shouldShowLoadingView?(false)
            switch $0 {
            case .success:
                AlertUtils.showSuccess("Báo cáo gửi thành công")
            case .failure(let error):
                AlertUtils.showError(error.errorMessage)
            }
        })
    }
}
