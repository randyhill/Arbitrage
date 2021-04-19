//
//  Position.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import SwiftUI

let annualizedReturnGoal: Double = 0.50 // 50%

class Position: Identifiable, Codable {
    enum Spread {
        case bid, ask
    }
    
    enum CodingKeys: CodingKey {
        case id, _symbol, bestCase, worstCase, bestPercentage, soonest, latest, isOwned, doNotify
    }
    
    var id: UUID
    var _symbol: String
    @Published var equity: Equity?
    var bestCase: Double?
    var worstCase: Double?
    var bestPercentage: Double
    var soonest: Date
    var latest: Date?
    @Published var isOwned: Bool
    var doNotify: Bool
    
    var symbol: String {
        get {
            return _symbol
        }
        set {
            _symbol = newValue.uppercased()
        }
    }

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
        guard let best = bestCase else {return 0.0 }
        if let worst = worstCase {
            return best * bestPercentage + worst * (1 - bestPercentage)
        }
        return best
    }
    
    var totalReturn: Double? {
        guard let price = price else {
            return 0
        }
        return AnnualizedReturn.returnCalc(sellAt: exitPrice, price: price)
    }

    var periodDays: Int {
        let now = Date()
        let soonestDays = now.daysUntil(soonest)
        if let latest = latest {
            let lastestDays = now.daysUntil(latest)
            var averaged = Double(soonestDays) * bestPercentage + Double(lastestDays) * (1 - bestPercentage)
            if averaged.truncatingRemainder(dividingBy: 1) >= 0.5 {
                averaged += 1
            }
            return Int(averaged)
        }
        return soonestDays
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
    
    init(ticker: String, best: Double = 0.0, worst: Double? = nil, bestPercentage: Double = 0.5, soonest: Date = Date(), latest: Date? = nil, isOwned: Bool = false, buyNotifications: Bool = true) {
        self.id = UUID()
        self._symbol = ticker.uppercased()
        self.bestCase = best
        self.worstCase = worst
        self.bestPercentage = bestPercentage
        self.soonest = soonest
        self.latest = latest
        self.isOwned = isOwned
        self.doNotify = buyNotifications
    }
    
    convenience init() {
        self.init(ticker: "")
    }
    
    convenience init(best: Double = 0.0, worst: Double? = nil, latestPrice: Double, bid: Double, ask: Double, soonest: Date, latest: Date, bestPercentage: Double = 0.5)  {
        self.init()
        self.soonest = soonest
        self.latest = latest
        self.bestPercentage = bestPercentage
        self.equity = Equity(latestPrice: latestPrice, bid: bid, ask: ask)
        self.bestCase = best
        self.worstCase = worst
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self._symbol = try container.decode(String.self, forKey: ._symbol)
        self.bestCase = try container.decode(Double.self, forKey: .bestCase)
        self.worstCase = try container.decode(Double.self, forKey: .worstCase)
        self.bestPercentage = try container.decode(Double.self, forKey: .bestPercentage)
        self.soonest = try container.decode(Date.self, forKey: .soonest)
        self.latest = try container.decode(Date.self, forKey: .latest)
        self.isOwned = try container.decode(Bool.self, forKey: .isOwned)
        self.doNotify = try container.decode(Bool.self, forKey: .doNotify)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(_symbol, forKey: ._symbol)
        try container.encode(bestCase, forKey: .bestCase)
        try container.encode(worstCase, forKey: .worstCase)
        try container.encode(bestPercentage, forKey: .bestPercentage)
        try container.encode(soonest, forKey: .soonest)
        try container.encode(latest, forKey: .latest)
        try container.encode(isOwned, forKey: .isOwned)
        try container.encode(doNotify, forKey: .doNotify)
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
