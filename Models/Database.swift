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
    
    
    @Published var positions = [Position]()
    @Published var equities = [String: Equity]()
    
    init() {
        addPosition("TSLA", best: 1000.0, worst: 100,  soonest: Date().add(days: 1), latest: Date().add(months: 13))
        addPosition("AAPL", best: 800.0, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))
    }
    
    func addPosition(_ ticker: String, best: Double = 0.0, worst: Double = 0.0, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false) {
        positions += [Position(ticker: ticker, best: best, worst: worst, soonest: soonest, latest: latest, isOwned: isOwned)]
        ServerAPI.getEquity(ticker: ticker) { equity in
            self.equities[ticker] = equity
        }
    }
    
    func getEquityFor(_ ticker: String) -> Equity? {
        return equities[ticker]
    }
}
