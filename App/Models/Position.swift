//
//  Position.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import SwiftUI

let annualizedReturnGoal: Double = 0.50 // 50%

class Position: Identifiable {
    enum Spread {
        case bid, ask
    }
    
    var id: UUID
    var symbol: String
    @Published var equity: Equity?
    var bestCase: Double?
    var worstCase: Double?
    var bestPercentage: Double
    var soonest: Date
    var latest: Date
    @Published var isOwned: Bool
    var buyNotifications: Bool
    
    var price: Double? {
        return equity?.latestPrice
    }
    
    var askPrice: Double? {
        return equity?.ask ?? equity?.latestPrice
    }
    
    var bidPrice: Double? {
        return equity?.bid ?? equity?.latestPrice
    }

    var priceString: String {
        guard let price = price else { return "n/a" }
        return "$\(price.formatToDecimalPlaces())"
    }
    
    var exitPrice: Double {
        guard let best = bestCase, let worst = worstCase else {return 0.0 }
        return best * bestPercentage + worst * (1 - bestPercentage)
    }
    
    var totalReturn: Double? {
        guard let price = price else {
            return 0
        }
        return AnnualizedReturn.returnCalc(sellAt: exitPrice, price: price)
    }
    
    // if we bought at the ask, what return should wee expect?
//    var purchaseTotalReturn: Double? {
//        guard let price = askPrice else {
//            return 0
//        }
//        return AnnualizedReturn.returnCalc(sellAt: exitPrice, price: price)
//    }
//
//    // If we sold at the bid, what return would we be giving up?
//    var saleTotalReturn: Double? {
//        guard let price = bidPrice else {
//            return 0
//        }
//        return AnnualizedReturn.returnCalc(sellAt: exitPrice, price: price)
//    }

    var periodDays: Int {
        let now = Date()
        let soonestDays = now.daysUntil(soonest)
        let lastestDays = now.daysUntil(latest)
        let averaged = soonestDays * bestPercentage + lastestDays * (1 - bestPercentage)
        return Int(averaged)
    }
    
    var endDate: Date {
        return Date().add(days: periodDays)
    }
    
    var annualizedReturn: Double? {
        guard let price = price else {
            return 0
        }
        return AnnualizedReturn.calc(sellAt: exitPrice, price: price, days: periodDays)
    }
    
//    var bidReturn: Double? {
//        guard let price = askPrice else {
//            return 0
//        }
//        return AnnualizedReturn.calc(sellAt: exitPrice, price: price, days: periodDays)
//    }
//
//    var askReturn: Double? {
//        guard let price = bidPrice else {
//            return 0
//        }
//        return AnnualizedReturn.calc(sellAt: exitPrice, price: price, days: periodDays)
//    }

    // At what price will we meet our annulaized return goal..
    var buyPrice: Double {
        let years = Double(periodDays)/365.242199
        let tReturn = pow(1 + annualizedReturnGoal, years) - 1
        let _goalReturnsPrice = tReturn * exitPrice
        return _goalReturnsPrice
    }
    
    var bestCaseString: String {
        get {
            guard let best = bestCase else { return "" }
            return "\(best.formatToDecimalPlaces())"
        }
        set {
            guard let newDouble = newValue.double else {
                bestCase = nil
                return Log.error("Can't convert \(newValue) to double")
            }
            bestCase = newDouble
         }
    }
    
    var worstCaseString: String {
        get {
            guard let worst = worstCase else { return "" }
            return "\(worst.formatToDecimalPlaces())"
        }
        set {
            guard let newDouble = newValue.double else {
                worstCase = nil
                return Log.error("Could not convert: \(newValue) to double")
            }
            worstCase = newDouble
        }
    }
    
    var companyName: String {
        return equity?.companyName ?? "No Data"
    }
    
    init(ticker: String, best: Double = 0.0, worst: Double = 0.0, bestPercentage: Double = 0.5, soonest: Date = Date(), latest: Date = Date(), isOwned: Bool = false, buyNotifications: Bool = true) {
        self.id = UUID()
        self.symbol = ticker
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
    
    convenience init(best: Double = 0.0, worst: Double = 0.0, latestPrice: Double, bid: Double, ask: Double, soonest: Date, latest: Date, bestPercentage: Double = 0.5)  {
        self.init()
        self.soonest = soonest
        self.latest = latest
        self.bestPercentage = bestPercentage
        self.equity = Equity(latestPrice: latestPrice, bid: bid, ask: ask)
        self.bestCase = best
        self.worstCase = worst
    }
    
    func annualizedReturnFor(_ spread: Spread) -> AnnualizedReturn {
        switch spread {
        case .ask:
            return AnnualizedReturn(price: askPrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .bid:
            return AnnualizedReturn(price: bidPrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
       }
    }
}
