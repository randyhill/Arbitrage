//
//  Database.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import Foundation
import SwiftUI

class Database: ObservableObject {
    static let testPositions = [Position(ticker: "TSLA", best: 1000.0321, worst: 100,  soonest: Date().add(days: 1), latest: Date().add(months: 13)), Position(ticker: "AAPL", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))]
    
    @Published var positions = [Position]()
    @Published var equities = [Equity]()
    private var positionHash = [String: Position]()
    private var equityHash = [String: Equity]()
    
    var newPosition: Position {
        return Position()
    }
    
    init() {
        addPosition("TSLA", best: 1000.0321, worst: 100,  soonest: Date().add(days: 1), latest: Date().add(months: 13))
        addPosition("AAPL", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))
    }
    
    func getEquityFor(_ ticker: String) -> Equity? {
        return equityHash[ticker]
    }
    
    func addEquity(ticker: String, equity: Equity) {
        equities += [equity]
        equityHash[ticker] = equity
    }
    
    func positionAt(_ index: Int) -> Position {
        return positions[index]
    }
    
    func addPosition(_ ticker: String, best: Double = 0.0, worst: Double = 0.0, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false)
    {
        let position = Position(ticker: ticker, best: best, worst: worst, soonest: soonest, latest: latest, isOwned: isOwned)
        addPosition(position)
    }
    
    func addPosition(_ newPosition: Position) {
        Log.threadCheck(shouldBeMain: true)
        positions.append(newPosition)
        positionHash[newPosition.symbol] = newPosition
        refreshSymbolData(newPosition.symbol) { equity in
            newPosition.equity = equity
        }
    }
    
    private func refreshSymbolData(_ symbol: String, completion: @escaping (_ equity: Equity)->Void) {
        guard symbol.count > 0 else {
            return Log.error("Passed empty symbol")
        }
        ServerAPI.getEquity(ticker: symbol) { equity in
            DispatchQueue.main.async {
                // Data changes need to happen on main thread?
                self.addEquity(ticker: symbol, equity: equity)
                completion(equity)
            }
        }
    }
}
