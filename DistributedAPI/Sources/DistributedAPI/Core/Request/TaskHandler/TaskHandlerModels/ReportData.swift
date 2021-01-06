//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 13/12/2020.
//

import Foundation

public struct ReportData {
    public init(id: Int, title: String, content: String, image: Data? = nil, video: Data? = nil, imageFileName: String? = nil, videoFileName: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.image = image
        self.video = video
        self.imageFileName = imageFileName
        self.videoFileName = videoFileName
    }
    
    public var id: Int
    public var title: String
    public var content: String
    public var image: Data?
    public var video: Data?
    public var imageFileName: String?
    public var videoFileName: String?
}

public extension ReportData {
    func toMultipartFormData() -> [MultipartFormData] {
        var formData: [MultipartFormData] = [
            .init(provider: .string("\(id)"), name: "id"),
            .init(provider: .string(title), name: "title"),
            .init(provider: .string(content), name: "content")
        ]
        
        if let image = image {
            formData.append(.init(provider: .data(image), name: "file", fileName: imageFileName, mimeType: "image/png"))
        }
        
        if let video = video {
            formData.append(.init(provider: .data(video), name: "image", fileName: videoFileName, mimeType: "image/png"))
        }
        
        return formData
    }
}
