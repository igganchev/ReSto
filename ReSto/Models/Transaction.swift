//
//  Transaction.swift
//  ReSto
//
//  Created by Todor Angelov on 15.12.19.
//

import Foundation

class Transaction: Codable, Identifiable, JSONGeneratable {
    
    let name: String
    let id: Int
    let user_id: Int?
    let date: String
    let sum: Double
    let card: String
    let location: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case user_id = "user_id"
        case date = "date"
        case sum = "sum"
        case card = "card"
        case location = "location"
    }
    
    init(name: String, id: Int, user_id: Int?, date: String, sum: Double, card: String, location:String) {
        self.name = name
        self.id = id
        self.user_id = user_id
        self.date = date
        self.sum = sum
        self.card = card
        self.location = location
    }
    
    required convenience init(data: Data) throws {
        let arr = try JSONDecoder().decode(Array<Transaction>.self, from: data)
        if let me = arr.first {
            self.init(name: me.name, id: me.id, user_id: me.user_id, date: me.date, sum: me.sum, card: me.card, location: me.location)
        } else {
            self.init(name: "", id: 0, user_id: 0, date: "", sum: 0, card: "", location: "")
        }
    }
    
    func getDate() -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM, HH:mm"

        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        } else {
            return nil
        }
    }
    
    func next$(a: Double, n: Double) -> Double {
        return ceil(a/n) * n;
    }
    
    func getAmount() -> String? {
        return CurrencyFormatter.formatAsEuro(double: self.sum)
    }
    
    
    func getSaved() -> String? {
        return CurrencyFormatter.formatAsEuro(double: self.next$(a: self.sum, n: 5) - self.sum)
    }
}
