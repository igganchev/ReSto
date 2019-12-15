//
//  Goal.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Foundation

class Goal: Codable, JSONGeneratable {
    let name: String
    let id: Int
    let goalSum: Int
    let currentSum: Int
    let createdById: Int
    let image: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case goalSum = "goalSum"
        case currentSum = "currentSum"
        case createdById = "created-by"
        case image = "image"
    }
    
    init(name: String, id: Int, goalSum: Int, currentSum: Int, createdBy: Int, image: [String]) {
        self.name = name
        self.id = id
        self.goalSum = goalSum
        self.currentSum = currentSum
        self.createdById = createdBy
        self.image = image
    }
    
    required convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(Goal.self, from: data)
        self.init(name: me.name, id: me.id, goalSum: me.goalSum, currentSum: me.currentSum, createdBy: me.createdById, image: me.image)
    }
}
