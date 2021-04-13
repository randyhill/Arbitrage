//
//  Position.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import SwiftUI

class Position: Codable, Identifiable {
    let id: UUID
    var ticker: String
    var bestCase: Double
    var worstCase: Double
    var soonest: Date
    var latest: Date
    var isOwned: Bool
    var buyNotifications: Bool
    
    var currentState: String {
        if let equity = Database.shared.getEquityFor(ticker) {
            return equity.title
        }
        return ticker + ": no data"
    }
    
    var bestCaseString: String {
        get {
            return "\(bestCase.formatted)"
        }
        set {
            guard let newDouble = Double(newValue) else {
                return Log.error("Could not convert: \(newValue) to double")
            }
            bestCase = newDouble
        }
    }
    
    var bestCaseDescription: String {
        return "Best Case: $\(bestCase.formatted) by: \(soonest.toFullUniqueDate())"
    }
    
    var worstCaseDescription: String {
        return "Worst Case: $\(worstCase.formatted) by: \(latest.toFullUniqueDate())"
    }

    init(ticker: String, best: Double = 0.0, worst: Double = 0.0, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false, buyNotifications: Bool = true) {
        self.id = UUID()
        self.ticker = ticker
        self.bestCase = best
        self.worstCase = worst
        self.soonest = soonest
        self.latest = latest
        self.isOwned = isOwned
        self.buyNotifications = buyNotifications
    }
}
