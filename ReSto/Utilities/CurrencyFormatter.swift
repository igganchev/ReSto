//
//  CurrencyFormatter.swift
//  ReSto
//
//  Created by Ivan Ganchev on 30.12.19.
//

import Foundation

class CurrencyFormatter {
    
    static func formatAsEuro(double: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: double as NSNumber) {
            return formattedAmount
        } else {
            return nil
        }
    }
}
