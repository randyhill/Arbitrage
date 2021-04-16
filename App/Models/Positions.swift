//
//  Positions.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/14/21.
//

import SwiftUI

class Positions: ObservableObject {
    private var hash = [String: Position]()
    
    var list: [Position] {
        return Array(hash.values)
    }
    
    func add(_ newPosition: Position) {
        hash[newPosition.symbol] = newPosition
        objectWillChange.send()
    }
    
    func update(_ position: Position) {
        hash[position.symbol] = position
        objectWillChange.send()
    }
}

