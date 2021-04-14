//
//  Positions.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/14/21.
//

import SwiftUI

class Positions: ObservableObject {
    private var hash = [String: Position]()
    
    var positions: [Position] {
        return Array(hash.values)
    }
    
    func add(_ newPosition: Position) {
        hash[newPosition.ticker] = newPosition
        objectWillChange.send()
    }
    
    func update(_ position: Position) {
        hash[position.ticker] = position
        objectWillChange.send()
    }
}

