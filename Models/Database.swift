//
//  Database.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import Foundation
import SwiftUI

class Positions: ObservableObject {
    var positions = [Position]()
    
    func addPosition(_ ticker: String, best: Double = 0.0, worst: Double = 0.0, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false) {
        positions += [Position(ticker: ticker, best: best, worst: worst, soonest: soonest, latest: latest, isOwned: isOwned)]
        ServerAPI.getEquity(ticker: ticker) { equity in
            Database.shared.addEquity(ticker: ticker, equity: equity)
        }
    }
}

class Database: ObservableObject {
    static let shared = Database()
    
    @Published private var ps = Positions()
    @Published private var equities = [String: Equity]()
    
    var positions: [Position] {
        return ps.positions
    }
    
    init() {
        ps.addPosition("TSLA", best: 1000.0, worst: 100,  soonest: Date().add(days: 1), latest: Date().add(months: 13))
        ps.addPosition("AAPL", best: 800.0, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))
    }
    
    func getEquityFor(_ ticker: String) -> Equity? {
        return equities[ticker]
    }
    
    func addEquity(ticker: String, equity: Equity) {
        self.equities[ticker] = equity
    }
}
