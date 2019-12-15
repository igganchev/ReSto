//
//  Transaction.swift
//  ReSto
//
//  Created by Todor Angelov on 15.12.19.
//

import Foundation

class Transaction: Codable, JSONGeneratable {
    
    let name: String
    let id: Int
    let date: Date
    let sum: Double
    let card: String
    let location: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case date = "date"
        case sum = "sum"
        case card = "card"
        case location = "location"
    }
    
    init(name: String, id: Int, date: Date, sum: Double, card: String, location:String) {
        self.name = name
        self.id = id
        self.date = date
        self.sum = sum
        self.card = card
        self.location = location
    }
    
    required convenience init(data: Data) throws {
           let me = try JSONDecoder().decode(Transaction.self, from: data)
           self.init(name: me.name, id: me.id, date: me.date, sum: me.sum, card: me.card, location: me.location)
    }
}
