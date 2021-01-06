//
//  MultipartFormData.swift
//  Sapo
//
//  Created by Kien Nguyen on 1/8/20.
//  Copyright © 2020 Sapo Technology JSC. All rights reserved.
//

import Foundation
#if !os(macOS)
import MobileCoreServices
#else
import CoreServices
#endif

struct MultipartFormDataChars {
    static let crlf = "\r\n"
}

struct MultipartFormDataMimeType {
    static let octetStream = "application/octet-stream"
}

public protocol MultipartFormDataType {
    func getData(boundary: String) -> Data
}

public struct MultipartFormData: MultipartFormDataType {
    
    public enum Provider {
        case string(String)
        case data(Data)
        case file(URL)
    }
    
    let provider: Provider
    
    let name: String
    
    private let fileName: String?
    private let mimeType: String?
    
    public init(provider: Provider,
                name: String,
                fileName: String? = nil,
                mimeType: String? = nil) {
        
        self.name = name
        self.provider = provider
        self.fileName = fileName
        self.mimeType = mimeType
    }
    
    public func getData(boundary: String) -> Data {
        switch provider {
        case .string(let string):
            var formData = Data()
            formData.append("--\(boundary)\(MultipartFormDataChars.crlf)".data())
            formData.append("Content-Disposition: form-data; name=\"\(name)\"\(MultipartFormDataChars.crlf)\(MultipartFormDataChars.crlf)".data())
            formData.append("\(string)\(MultipartFormDataChars.crlf)".data())
            return formData
            
        case .data(let data):
            let fileName = self.fileName ?? "file"
            let mimeType = self.mimeType ?? MultipartFormDataMimeType.octetStream
            
            return formData(with: data, boundary: boundary, fileName: fileName, mimeType: mimeType)
            
        case .file(let url):
            guard let data = try? Data(contentsOf: url) else {
                return Data()
            }
            
            let fileName = url.lastPathComponent
            let mimeType = contentType(for: url.pathExtension)
            
            return formData(with: data, boundary: boundary, fileName: fileName, mimeType: mimeType)
        }
    }
    
    private func formData(with data: Data, boundary: String, fileName: String, mimeType: String) -> Data {
        var formData = Data()
        
        formData.append("--\(boundary)\(MultipartFormDataChars.crlf)".data())
        formData.append("Content-Disposition: form-data; name=\"\(name)\"; ".data()) // last space is required
        formData.append("filename=\"\(fileName)\"\(MultipartFormDataChars.crlf)".data())
        formData.append("Content-Type: \(mimeType)\(MultipartFormDataChars.crlf)\(MultipartFormDataChars.crlf)".data())
        formData.append(data)
        formData.append(MultipartFormDataChars.crlf.data())
        
        return formData
    }
    
}

protocol MultipartFormDataBuilderType {
    var boundary: String { get }
    func build() -> Data
}

class MultipartFormDataBuilder: MultipartFormDataBuilderType {
    
    lazy var boundary = String(format: "distributed.boundary.%08x%08x", arc4random(), arc4random())
    
    private var httpBody = Data()
    private var forms = [MultipartFormDataType]()
    
    @discardableResult
    func append(_ formData: MultipartFormDataType) -> MultipartFormDataBuilder {
        forms.append(formData)
        return self
    }
    
    func build() -> Data {
        forms.forEach {
            httpBody.append($0.getData(boundary: boundary))
        }
        
        httpBody.append("--\(boundary)--\(MultipartFormDataChars.crlf)".data())
        return httpBody
    }
}

extension URLRequest {
    init(multipartFormDataBuilder builder: MultipartFormDataBuilderType,
         url: URL,
         method: HTTPMethod = .post,
         headers: [String: String]? = nil) {
        
        self.init(url: url)
        self.httpMethod = method.rawValue.uppercased()
        
        let body = builder.build()
        self.httpBody = body
        
        headers?.forEach { self.setValue($0.value, forHTTPHeaderField: $0.key) }
        self.setValue("multipart/form-data; boundary=\(builder.boundary)", forHTTPHeaderField: "Content-Type")
        self.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
    }
    
    mutating func setMultipartFormDataBuilder(builder: MultipartFormDataBuilderType) {
        let body = builder.build()
        self.httpBody = body
        self.setValue("multipart/form-data; boundary=\(builder.boundary)", forHTTPHeaderField: "Content-Type")
        self.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
    }
}

private func contentType(for pathExtension: String) -> String {
    guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue() else {
        return MultipartFormDataMimeType.octetStream
    }
    
    let contentTypeCString = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
    
    guard let contentType = contentTypeCString as String? else {
        return MultipartFormDataMimeType.octetStream
    }
    
    return contentType
}

private extension String {
    func data() -> Data {
        return self.data(using: .utf8) ?? Data()
    }
}
