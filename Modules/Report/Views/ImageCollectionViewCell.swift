//
//  ImageCollectionViewCell.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 06/12/2020.
//

import UIKit

enum ImageType: Equatable {
    case normal(image: UIImage?)
    case imagePicker
    
    var image: UIImage? {
        switch self {
        case .imagePicker:
            return UIImage(named: "ic_add_photos")?.alwaysTemplate()
        case .normal(let image):
            return image
        }
    }
}

class ImageCollectionViewCell: UICollectionViewCell {

    static let height: CGFloat = 64
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFit
    }
    
    func updateImageView(_ image: ImageType) {
        imageView.image = image.image
        imageView.layer.cornerRadius = 4
        
        if image == .imagePicker {
            imageView.tintColor = .icon
        }
    }

}
