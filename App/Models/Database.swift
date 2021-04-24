//
//  Database.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import Foundation
import SwiftUI

class Database: ObservableObject {
    static let testPositions = [Position(ticker: "TSLA", best: 1000.0321, worst: nil,  soonest: Date().add(days: 1), latest: Date().add(days: 2)),
                                Position(ticker: "AAPL", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7)),
                                Position(ticker: "RUN", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))]
    
    static var testPosition: Position {
        let position = Position(ticker: "AAPL", best: 200.0, worst: 140,  soonest: Date().add(months: 10), latest: Date().add(years: 2))
        position.equity = Equity(latestPrice: 134.25, bid: 134.25, ask: 134.30)
        return position
    }
    
    static var testPosition2: Position {
        let position = Position(ticker: "AAPL", best: 200.0, worst: 140,  soonest: Date().add(months: 10), latest: Date().add(years: 2))
        position.equity = Equity(latestPrice: 134.25, bid: nil, ask: nil)
        return position
    }

    @Published var positions = [Position]()
    @Published var equities = [Equity]()
    private var positionHash = [String: Position]()
    private var equityHash = [String: Equity]()
    private var fileName = "positions.arb"
    
    var newPosition: Position {
        return Position()
    }
    
    var sorted: [Position] {
         let sortedPositions = positions.sorted { first, second in
            first.annualizedReturnFor(.ask) > second.annualizedReturnFor(.ask)
        }
        return sortedPositions
    }
    
    init() {
        if !load() {
            positions.append(contentsOf: (Database.testPositions))
        }
        refreshAllSymbols()
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
    
    func refreshAllSymbols() {
        for position in positions {
            refreshSymbolData(position.symbol) { newEquity in
                self.addEquity(ticker: position.symbol, equity: newEquity)
                position.equity = newEquity
            }
        }
    }
    
    private func refreshSymbolData(_ symbol: String, completion: @escaping (_ equity: Equity)->Void) {
        guard symbol.count > 0 else {
            return Log.error("Passed empty symbol")
        }
        ServerAPI.getEquity(ticker: symbol) { equity in
            // Data changes need to happen on main thread?
            DispatchQueue.main.async {
#if DEV
                let equity = self.addTestDataTo(equity: equity)
#endif
                self.addEquity(ticker: symbol, equity: equity)
                completion(equity)
            }
        }
    }
    
#if DEV
    private func addTestDataTo(equity: Equity) -> Equity {
        // Give us bid/ask outside of regular hours.
        if equity.ask == nil, equity.latestPrice > 0 {
            return Equity(equity.symbol, latestPrice: equity.latestPrice, bid: equity.latestPrice * 0.9, ask: equity.latestPrice * 1.15)
        }
        return equity
    }
#endif

    
    private func getDocumentURL() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        let documentsURL = paths[0]
        return documentsURL.appendingPathComponent(fileName)
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return Log.error("Weak self in file save") }
            guard let data = try? JSONEncoder().encode(self.positions) else { return Log.error("Error encoding data") }
            do {
                let url = self.getDocumentURL()
                try data.write(to: url)
            } catch {
                Log.error("Can't write to tasks file: \(error)")
            }
        }
    }
    
    func load() -> Bool {
        let url = getDocumentURL()
        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let decoder = JSONDecoder()
                self.positions = try decoder.decode([Position].self, from: data)
            } catch {
                Log.error("Error: \(error.localizedDescription) trying to read: \(url.path)")
                return false
            }
        } else {
            Log.error("No data at \(url.path)")
            return false
        }
        return true
    }
}
