//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

extension JSONEncoder.DateEncodingStrategy {
    static let customDSD08 = JSONEncoder.DateEncodingStrategy.custom { (date, encoder) in
        let dateString = date.toString(format: .customDateTimeSecWithoutZone)
        var container = encoder.singleValueContainer()
        try container.encode(dateString)
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customDSD08 = custom { (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Date(fromString: string, format: .customDateTimeSecWithoutZone) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
