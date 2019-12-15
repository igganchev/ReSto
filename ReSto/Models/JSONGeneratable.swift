//
//  JSONGeneratable.swift
//  ReSto
//
//  Created by Ivan Ganchev on 15.12.19.
//

import Foundation

protocol JSONGeneratable {
    init(data: Data) throws
}
   
extension JSONGeneratable {
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
}
