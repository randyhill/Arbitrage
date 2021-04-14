//
//  Database.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import Foundation
import SwiftUI


class Database: ObservableObject {
    static let shared = Database()
    
    static let testPositions = [Position(ticker: "TSLA", best: 1000.0321, worst: 100,  soonest: Date().add(days: 1), latest: Date().add(months: 13)), Position(ticker: "AAPL", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))]
    
    @Published private var ps = Positions()
    @Published private var equities = [String: Equity]()
    
    var positions: [Position] {
        return ps.positions
    }
    
    var newPosition: Position {
        return Position()
    }
    
    init() {
        addPosition("TSLA", best: 1000.0321, worst: 100,  soonest: Date().add(days: 1), latest: Date().add(months: 13))
        addPosition("AAPL", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))
    }
    
    func getEquityFor(_ ticker: String) -> Equity? {
        return equities[ticker]
    }
    
    func addEquity(ticker: String, equity: Equity) {
        equities[ticker] = equity
        objectWillChange.send()
    }
    
    func addPosition(_ ticker: String, best: Double = 0.0, worst: Double = 0.0, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false)
    {
        let position = Position(ticker: ticker, best: best, worst: worst, soonest: soonest, latest: latest, isOwned: isOwned)
        addPosition(position)
    }
    
    func addPosition(_ newPosition: Position) {
        ps.add(newPosition)
        ServerAPI.getEquity(ticker: newPosition.ticker) { equity in
            newPosition.equity = equity
            self.updatePosition(newPosition)
            self.addEquity(ticker: newPosition.ticker, equity: equity)
        }
        objectWillChange.send()
    }
    
    func updatePosition(_ position: Position) {
        ps.update(position)
        objectWillChange.send()
     }
}
