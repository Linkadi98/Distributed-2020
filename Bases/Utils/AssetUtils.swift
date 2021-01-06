//
//  AssetUtils.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 13/12/2020.
//

import Foundation
import Photos

class AssetUtils {
    
    enum ImageSize: String {
        case pico
        case icon
        case thumb
        case small
        case compact
        case medium
        case large
        case grande
        //        case s1024
        case s2048
        
        func numericValue() -> CGFloat {
            switch self {
            case .pico: return 16
            case .icon: return 32
            case .thumb: return 50
            case .small: return 100
            case .compact: return 160
            case .medium: return 240
            case .large: return 480
            case .grande: return 600
            //            case .s1024: return 1024
            case .s2048: return 2048
            }
        }
    }
    
    static func assetThumbnail(from asset: PHAsset, size: ImageSize) -> UIImage {
        let sizeValue = size.numericValue()
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width: sizeValue * retinaScale, height: sizeValue * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x: 0, y: 0, width: CGFloat(cropSizeLength), height: CGFloat(cropSizeLength))
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0 / CGFloat(asset.pixelWidth), y: 1.0 / CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
}
