//
//  UIImage+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation
import UIKit
import Photos

extension UIImage {
    
    private static let maximumImageSize: Int = 1 * 1024 * 1024 // 1MB
    private static let maximumImageWidth: CGFloat = 1024
    
    func alwaysTemplate() -> UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    static func alwaysTemplate(named name: String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
    }
    
    convenience init?(base64String: String?) {
        guard let base64 = base64String, let data = Data(base64Encoded: base64) else {
            return nil
        }
        
        self.init(data: data)
    }
    
    func pixelData() -> [UInt32]? {
        //        let height = self.size.height * UIScreen.main.scale
        //        let width = self.size.width * UIScreen.main.scale
        let height = self.size.height
        let width = self.size.width
        let dataSize = width * height
        var pixelData = [UInt32](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelData
    }
    
    func convertToGrayScale() -> UIImage {
        guard let currentCGImage = self.cgImage else { return self }
        let currentCIImage = CIImage(cgImage: currentCGImage)
        
        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: kCIInputImageKey)
        
        // set a gray value for the tint color
        filter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: kCIInputColorKey)
        
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        guard let outputImage = filter?.outputImage else { return self}
        
        let context = CIContext()
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            
            return processedImage
        }
        
        return self
    }
    
    func grayScaled() -> UIImage? {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        guard let output = filter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }
    
    convenience init?(barcode: String) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        filter.setValue(0.0, forKey: "inputQuietSpace")
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }
        self.init(ciImage: ciImage)
    }
    
    static func from(color: UIColor,
                     size: CGSize = CGSize(width: 1, height: 1),
                     cornerRadius: CGFloat = 0.0) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(color.cgColor)
        
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect,
                         cornerRadius: cornerRadius)
                .fill()
        } else {
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func toBase64(maxWidth: CGFloat = UIImage.maximumImageWidth,
                  maxSize: Int = UIImage.maximumImageSize) -> String {
        var image: UIImage? = self
        
        if image?.size.width ?? 0.0 > maxWidth {
            image = resize(toMaxWidth: maxWidth)
        }
        
        let compressed = image?.compress(toMaxSize: maxSize)
        
        return compressed?.base64EncodedString() ?? ""
    }
    
    func compress(toMaxSize sizeInBytes: Int) -> Data? {
        guard let png = pngData() else {
            return nil
        }
        
        if png.count <= sizeInBytes {
            return png
        }
        
        var compression: CGFloat = 0.5
        let maxCompression: CGFloat = 0
        
        guard var imageData = jpegData(compressionQuality: compression) else {
            return nil
        }
        
        while imageData.count > sizeInBytes && compression > maxCompression {
            compression -= 0.1
            
            guard let data = jpegData(compressionQuality: compression) else {
                return nil
            }
            
            imageData = data
        }
        
        return imageData
    }
    
    func resize(toMaxWidth widthInPixels: CGFloat) -> UIImage? {
        let scale = widthInPixels / size.width
        let height = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: widthInPixels, height: height))
        draw(in: CGRect(x: 0, y: 0, width: widthInPixels, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Fix image orientaton to portrait up
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != .up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let ctx = CGContext(data: nil,
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    static let productPlaceholder = UIImage(named: "ic_default_product_image")?.alwaysTemplate()
}

// MARK: - HTML Editor Helpers
extension UIImage {
    
    func saveToTemporaryFile() -> URL? {
        let fileName = "\(ProcessInfo.processInfo.globallyUniqueString)_file.jpg"
        
        guard let data = self.jpegData(compressionQuality: 0.9) else {
            return nil
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        guard (try? data.write(to: fileURL, options: [.atomic])) != nil else {
            return nil
        }
        
        return fileURL
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func png() -> Data? {
        return pngData()
    }
}

extension PHAsset {
    func toImage(size: AssetUtils.ImageSize) -> UIImage {
        AssetUtils.assetThumbnail(from: self, size: size)
    }
}

extension PHAsset {
    
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: targetSize).image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        } else {
            return UIImage()
        }
    }
}
