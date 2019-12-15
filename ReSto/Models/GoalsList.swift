//
//  TrendingResult.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//


import Foundation

class GoalsList: Codable, JSONGeneratable {
    let ids: [Int]
    
    enum CodingKeys: String, CodingKey {
        case ids = "ids"
    }
    
    init(ids: [Int]) {
        self.ids = ids
    }
    
    required convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(GoalsList.self, from: data)
        self.init(ids: me.ids)
    }
}
