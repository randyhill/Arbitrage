//
//  Collections.swift
//  Ike
//
//  Created by Randy Hill on 11/26/20.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[ index] : nil
    }
}

extension MutableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[ index] : nil
        }

        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[ index] = newValue
            }
        }
    }
}
