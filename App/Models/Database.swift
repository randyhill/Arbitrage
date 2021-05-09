//
//  Database.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import Foundation
import SwiftUI

class Database: ObservableObject {
    static let testPositions = [Position(symbol: "TSLA", best: 1000.0321, worst: nil,  soonest: Date().add(days: 1), latest: Date().add(days: 2)),
                                Position(symbol: "AAPL", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7)),
                                Position(symbol: "RUN", best: 800.030, worst: 400.0,  soonest: Date().add(days: 3), latest: Date().add(days: 7))]

    static var testPosition: Position {
        let position = Position(symbol: "AAPL", best: 200.0, worst: 140,  soonest: Date().add(months: 10), latest: Date().add(years: 2))
        position.quote = Quote(latestPrice: 135.01, bid: 134.25, ask: 136.55)
        position.scenarios.add(Scenario(payout: 82, date: Date().add(months: 2), pctFraction: 0.5))
        position.scenarios.add(Scenario(payout: 64, date: Date().add(months: 4), pctFraction: 0.5))
        return position
    }

    static var testPosition2: Position {
        let position = Position(symbol: "AAPL", best: 200.0, worst: 140,  soonest: Date().add(months: 10), latest: Date().add(years: 2))
        position.quote = Quote(latestPrice: 134.25, bid: nil, ask: nil)
        return position
    }

    @Published var positions = [Position]()
    @Published var equities = [Quote]()
    @Published var lastScenario = Scenario()
    private var fileName = "positions.arb"
    
    var newPosition: Position {
        return Position()
    }
    
    var sorted: [Position] {
         let sortedPositions = positions.sorted { first, second in
            first.annualizedReturnFor(.purchase) > second.annualizedReturnFor(.purchase)
        }
        return sortedPositions
    }
    
    init() {
        _ = load()
        refreshAllSymbols()
    }
    
    // Eliminate positions with empty symbols
    func clean(_ dirtyPositions: [Position]) -> [Position] {
        let sortedPositions = dirtyPositions.filter({ position in
            return position.symbol.count > 0
        })
        return sortedPositions
    }

   private  func addEquity(symbol: String, quote: Quote) {
        equities += [quote]
    }
    
    func positionAt(_ index: Int) -> Position {
        return positions[index]
    }
    
    func addPosition(_ symbol: String, best: Double = 0.0, worst: Double = 0.0, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false)
    {
        let position = Position(symbol: symbol, best: best, worst: worst, soonest: soonest, latest: latest, isOwned: isOwned)
        addPosition(position)
    }
    
    func addPosition(_ newPosition: Position) {
        guard newPosition.symbol.count > 0 else {
            return Log.error("Can't add position without symbol")
        }
        Log.threadCheck(shouldBeMain: true)
        positions.append(newPosition)
        
        getSymbolQuote(newPosition.symbol) { quote in
            newPosition.quote = quote
            self.positions = self.sorted
        }
    }
    
    func symbolMatch(_ symbol: String ) -> Int? {
        for index in 0..<positions.count {
            let position = positions[index]
            if position.symbol == symbol {
                 return index
            }
        }
        return nil
    }
    
    func refreshAllSymbols(completion: (()->Void)? = nil) {
        Log.console("REFRESHING SYMBOLS")
        var fetchTasks = positions.count
        for position in positions {
            getSymbolQuote(position.symbol) { newEquity in
                if let newEquity = newEquity {
                    self.addEquity(symbol: position.symbol, quote: newEquity)
                    position.quote = newEquity
                    self.positions = self.sorted
                }
                
                // Keep track of tasks by count
                fetchTasks -= 1
                if fetchTasks <= 0 {
                    completion?()
                }
           }
        }
    }
        
    func getSymbolQuote(_ symbol: String, completion: @escaping (_ quote: Quote?)->Void) {
        guard symbol.count > 0 else {
            return Log.error("Passed empty symbol")
        }
        iexAPI.chainedQuote(symbol: symbol) { quote in
            // Data changes need to happen on main thread?
            DispatchQueue.main.async {
//    #if DEV
//                    let quote = self.addTestDataTo(quote: quote)
//    #endif
                if let quote = quote {
                    self.addEquity(symbol: symbol, quote: quote)
                    completion(quote)
                }
            }
        }
    }
    
//#if DEV
//    private func addTestDataTo(quote: Quote) -> Quote {
//        if quote.ask == nil, quote.latestPrice > 0 {
//            return Quote(quote.symbol, latestPrice: quote.latestPrice, bid: quote.latestPrice, ask: quote.latestPrice)
//        }
//        return quote
//    }
//#endif

    
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
                let diskPositions = try decoder.decode([Position].self, from: data)
                let cleaned = clean(diskPositions)
                self.positions = cleaned
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
