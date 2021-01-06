//
//  UICollectionView+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import Foundation

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(type cellType: T.Type) {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerClass(for cellClass: UICollectionViewCell.Type) {
        registerClass(for: cellClass, reuseId: cellClass.reuseIdentifier)
    }
    
    func registerClass(for cellClass: UICollectionViewCell.Type, reuseId: String) {
        register(cellClass, forCellWithReuseIdentifier: reuseId)
    }
    
    func registerHeaderView<T: UICollectionReusableView>(type cellType: T.Type) {
        register(cellType.nib,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerFooterView<T: UICollectionReusableView>(type cellType: T.Type) {
        register(cellType.nib,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerHeaderViewClass<T: UICollectionReusableView>(type cellType: T.Type) {
        register(cellType.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func registerFooterViewClass<T: UICollectionReusableView>(type cellType: T.Type) {
        register(cellType.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: cellType.reuseIdentifier)
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type,
                                                      withIdentifier identifier: String? = nil,
                                                      for indexPath: IndexPath) -> T {
        let reuseId = identifier ?? type.reuseIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? T else {
            fatalError("\(String(describing: self)) could not dequeue cell with identifier: \(reuseId)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String,
                                                                       type: T.Type,
                                                                       withIdentifier identifier: String? = nil,
                                                                       for indexPath: IndexPath) -> T {
        let reuseId = identifier ?? type.reuseIdentifier
        guard let view = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: reuseId, for: indexPath) as? T else {
            fatalError("\(String(describing: self)) could not dequeue reusable supplementary view with identifier: \(reuseId)")
        }
        return view
    }
}
