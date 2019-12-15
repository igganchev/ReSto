//
//  Token.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Foundation

class Token: Codable, JSONGeneratable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
    }
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    required convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Token.self, from: data)
        self.init(accessToken: me.accessToken)
    }
}
