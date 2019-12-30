//
//  Goal.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Foundation
import UIKit

class Goal: Codable, Identifiable, JSONGeneratable {
    let name: String
    let id: Int
    let goalSum: Int
    let currentSum: Int
    let createdById: Int
    let imageStr: [String]
    
    var image: UIImage? = nil
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case goalSum = "goalSum"
        case currentSum = "currentSum"
        case createdById = "created-by"
        case imageStr = "image"
    }
    
    init(name: String, id: Int, goalSum: Int, currentSum: Int, createdBy: Int, imageStr: [String]) {
        self.name = name
        self.id = id
        self.goalSum = goalSum
        self.currentSum = currentSum
        self.createdById = createdBy
        self.imageStr = imageStr
    }
    
    required convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Goal.self, from: data)
        self.init(name: me.name, id: me.id, goalSum: me.goalSum, currentSum: me.currentSum, createdBy: me.createdById, imageStr: me.imageStr)
    }
    
    func getCurrentAmount() -> String? {
        return CurrencyFormatter.formatAsEuro(double: Double(self.currentSum))
    }
    
    func getGoalAmount() -> String? {
        return CurrencyFormatter.formatAsEuro(double: Double(self.goalSum))
    }
}
