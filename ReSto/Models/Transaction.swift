//
//  Transaction.swift
//  ReSto
//
//  Created by Todor Angelov on 15.12.19.
//

import Foundation

class Transaction: Codable {
    var name: String = "Name of transaction"
    var date: String = "01.01.2020"
    var sum: Double = 0.0
    var saved: Double = 0.0
}
