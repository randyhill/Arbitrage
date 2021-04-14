//
//  Position.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import SwiftUI

class Position: Identifiable, ObservableObject {
    let id: UUID
    var ticker: String
    var bestCase: Double
    var worstCase: Double
    var bestPercentage: Double
    var soonest: Date
    var latest: Date
    var isOwned: Bool
    var buyNotifications: Bool
    
    var currentPrice: Double? {
        let equity = Database.shared.getEquityFor(ticker)
        return equity?.latestPrice
    }
    
    var priceString: String {
        if let price = currentPrice {
            return "$\(price.formatToDecimalPlaces())"
        }
        return "N/A"
    }
    
    var currentState: String {
        if let equity = Database.shared.getEquityFor(ticker) {
            return equity.title
        }
        return ticker + ": no data"
    }
    
    var outcome: Double {
        return bestCase * bestPercentage + worstCase * (1 - bestPercentage)
    }
    
    var totalReturn: Double? {
        guard let price = currentPrice else {
            return nil
        }
        let grossReturn = outcome
        return grossReturn/price - 1
    }
    
    var averageDays: Int {
        let now = Date()
        let soonestDays = now.daysUntil(soonest)
        let lastestDays = now.daysUntil(latest)
        let averaged = soonestDays * bestPercentage + lastestDays * (1 - bestPercentage)
        return Int(averaged)
    }
    
    // Cap at 1,000% percent cause, come-on man.
    var annualizedReturn: Double? {
        guard let grossReturn = totalReturn else { return nil }
        let negativeReturn = grossReturn < 0
        let years = Double(averageDays)/365.242199
        let annualized = (pow(1 + grossReturn, 1/years))
        if negativeReturn {
            if annualized > 10 {
                return -10
            }
            return -annualized
        } else {
            if annualized > 10 { return 10 }
            return annualized - 1
        }
    }
    
    var bestCaseString: String {
        get {
            return "\(bestCase.formatToDecimalPlaces())"
        }
        set {
            guard let newDouble = newValue.double else {
                return Log.error("Could not convert: \(newValue) to double")
            }
            bestCase = newDouble
            self.objectWillChange.send()
        }
    }
    
    var worstCaseString: String {
        get {
            return "\(worstCase.formatToDecimalPlaces())"
        }
        set {
            guard let newDouble = newValue.double else {
                return Log.error("Could not convert: \(newValue) to double")
            }
            worstCase = newDouble
            self.objectWillChange.send()
        }
    }

    
    var bestCaseDescription: String {
        return "Best Case: $\(bestCase.formatted) by \(soonest.toFullUniqueDate())"
    }
    
    var worstCaseDescription: String {
        return "Worst Case: $\(worstCase.formatted) by \(latest.toFullUniqueDate())"
    }

    init(ticker: String, best: Double = 0.0, worst: Double = 0.0, bestPercentage: Double = 0.5, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false, buyNotifications: Bool = true) {
        self.id = UUID()
        self.ticker = ticker
        self.bestCase = best
        self.worstCase = worst
        self.bestPercentage = bestPercentage
        self.soonest = soonest
        self.latest = latest
        self.isOwned = isOwned
        self.buyNotifications = buyNotifications
    }
    
    convenience init() {
        self.init(ticker: "")
    }
}
