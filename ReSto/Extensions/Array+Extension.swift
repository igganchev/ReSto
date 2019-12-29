//
//  Array+Extension.swift
//  ReSto
//
//  Created by Ivan Ganchev on 29.12.19.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
