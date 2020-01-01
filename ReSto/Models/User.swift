//
//  User.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Foundation
import UIKit

class User: Codable, JSONGeneratable {
    let name: String
    let id: Int
    let frequency: Int
    let roundingUp: Int
    let savedTotal: Double
    let numberOfTransactions: Int
    let imageStr: String
    
    var image: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case frequency = "frequency"
        case roundingUp = "roundingUp"
        case savedTotal = "savedTotal"
        case numberOfTransactions = "numberOfTransactions"
        case imageStr = "profilePic"
    }
    
    init(name: String, id: Int, frequency: Int, roundingUp: Int, savedTotal: Double, numberOfTransactions: Int, imageStr: String) {
        self.name = name
        self.id = id
        self.frequency = frequency
        self.roundingUp = roundingUp
        self.savedTotal = savedTotal
        self.numberOfTransactions = numberOfTransactions
        self.imageStr = imageStr
    }
    
    required convenience init(data: Data) throws {
        let me = try JSONDecoder().decode([User].self, from: data).first!
        self.init(name: me.name, id: me.id, frequency: me.frequency, roundingUp: me.roundingUp, savedTotal: me.savedTotal, numberOfTransactions: me.numberOfTransactions, imageStr: me.imageStr)
    }
}

