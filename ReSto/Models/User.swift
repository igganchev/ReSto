//
//  User.swift
//  ReSto
//
//  Created by Ivan Ganchev on 14.12.19.
//

import Foundation

class User: Codable, JSONGeneratable {
    let name: String
    let id: Int
    let eventsIds: [Int]
    let profilePicPath: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case eventsIds = "events"
        case profilePicPath = "profile-pic"
    }
    
    init(name: String, id: Int, events: [Int], profilePic: String) {
        self.name = name
        self.id = id
        self.eventsIds = events
        self.profilePicPath = profilePic
    }
    
    required convenience init(data: Data) throws {
        let me = try JSONDecoder().decode(User.self, from: data)
        self.init(name: me.name, id: me.id, events: me.eventsIds, profilePic: me.profilePicPath)
    }
}

