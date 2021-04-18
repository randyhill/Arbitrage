//
//  Position.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import SwiftUI

let annualizedReturnGoal: Double = 0.50 // 50%

class Position: Identifiable {
    var id: UUID
    var symbol: String
    @Published var equity: Equity?
    var bestCase: Double
    var worstCase: Double
    var bestPercentage: Double
    var soonest: Date
    var latest: Date
    var isOwned: Bool
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
    
    var outcome: Double {
        return bestCase * bestPercentage + worstCase * (1 - bestPercentage)
    }
    
    var totalReturn: Double? {
        guard let price = price else {
            return 0
        }
        return returnCalc(soldAt: outcome, boughtAt: price)
    }
    
    // if we bought at the ask, what return should wee expect?
    var purchaseTotalReturn: Double? {
        guard let price = askPrice else {
            return 0
        }
        return returnCalc(soldAt: outcome, boughtAt: price)
    }
    
    // If we sold at the bid, what return would we be giving up?
    var saleTotalReturn: Double? {
        guard let price = bidPrice else {
            return 0
        }
        return returnCalc(soldAt: outcome, boughtAt: price)
    }

    var periodDays: Int {
        let now = Date()
        let soonestDays = now.daysUntil(soonest)
        let lastestDays = now.daysUntil(latest)
        let averaged = soonestDays * bestPercentage + lastestDays * (1 - bestPercentage)
        return Int(averaged)
    }
    
    var annualizedReturn: Double? {
        guard let price = price else {
            return 0
        }
        return annualizedReturnCalc(soldAt: outcome, boughtAt: price, days: periodDays)
    }
    
    var bidReturn: Double? {
        guard let price = askPrice else {
            return 0
        }
        return annualizedReturnCalc(soldAt: outcome, boughtAt: price, days: periodDays)
    }
    
    var askReturn: Double? {
        guard let price = bidPrice else {
            return 0
        }
        return annualizedReturnCalc(soldAt: outcome, boughtAt: price, days: periodDays)
    }
    
    var bidColor: Color {
        return annualizedReturnColor(bidReturn)
    }
    
    var askColor: Color {
        return annualizedReturnColor(bidReturn)
    }

    // At what price will we meet our annulaized return goal..
    var goalPrice: Double {
        let years = Double(periodDays)/365.242199
        let tReturn = pow(1 + annualizedReturnGoal, years) - 1
        let _goalReturnsPrice = tReturn * outcome
        return _goalReturnsPrice
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
        }
    }
    
    var bestCaseDescription: String {
        return "Best Case: $\(bestCase.formatted) by \(soonest.toFullUniqueDate())"
    }
    
    var worstCaseDescription: String {
        return "Worst Case: $\(worstCase.formatted) by \(latest.toFullUniqueDate())"
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
    
    func annualizedReturnColor(_ annualizedReturn: Double?) -> Color {
        guard let annualizedReturn = annualizedReturn else {
            return Color.gray
        }
        if annualizedReturn >= 0.5 {
            return Color.coolGreen
        }
        if annualizedReturn >= 0.35 {
            return Color.coolBlue
        }
        if isOwned {
            if annualizedReturn <= 0.10 {
                return Color.coolRed
            }
            if annualizedReturn <= 0.20 {
                return Color.coolYellow
            }
        }
        return Color.white
    }
    
    private func returnCalc(soldAt: Double, boughtAt: Double) -> Double {
        return soldAt/boughtAt - 1
    }

    // Cap at 1,000% percent cause, come-on man.
    // Since we are using days instead of years there is a minor amount of imprecision since we ignore leap years
    private func annualizedReturnCalc(soldAt: Double, boughtAt: Double, days: Int) -> Double {
        let grossReturn = returnCalc(soldAt: soldAt, boughtAt: boughtAt)
        let negativeReturn = grossReturn < 0
        let years = Double(days)/364
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
}
