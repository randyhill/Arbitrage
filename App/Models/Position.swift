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
        case bid, ask, mid, purchasePrice
    }
    
    enum CodingKeys: CodingKey {
        case id, _symbol, bestCase, worstCase, bestPercentage, soonest, latest, isOwned, doNotify, annualized, scenarios
    }
    
    let id: String
    var _symbol: String
    @Published var equity: Equity?
    @Published var isOwned: Bool
    var annualized: Double
    var doNotify: Bool                  // Ignore this position for alerts
    var scenarios: PositionScenarios
    
    var symbol: String {
        get {
            return _symbol
        }
        set {
            _symbol = newValue.uppercased()
        }
    }

    var purchasePrice: Double? {
        if let ask = askPrice {
            return ask
        }
        if let bid = bidPrice {
            return bid
        }
        return equity?.latestPrice
    }
    
    var midPoint: Double? {
        if let ask = askPrice, let bid = bidPrice {
            return (ask + bid)/2
        }
        return nil
    }
    
    var askPrice: Double? {
        if let ask = equity?.ask, ask > 0 {
            return ask
        }
        return nil
    }
    
    var bidPrice: Double? {
        if let bid = equity?.bid, bid > 0 {
            return bid
        }
        return nil
    }

    var priceString: String {
        guard let price = purchasePrice else { return "n/a" }
        return "$\(price.formatToDecimalPlaces())"
    }
    
    var exitPrice: Double {
         return scenarios.averagePayout
    }
    
    var totalReturn: Double? {
        guard let price = purchasePrice else {
            return 0
        }
        return AnnualizedReturn.returnCalc(sellAt: exitPrice, price: price)
    }

    var periodDays: Int {
        return scenarios.averageDays
    }
    
    var endDate: Date {
        return Date().add(days: periodDays)
    }
    
    var annualizedReturn: Double? {
        guard let price = purchasePrice else {
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
    
    var companyName: String {
        return equity?.companyName ?? "No Data"
    }
    
    init(ticker: String, best: Double = 0.0, worst: Double? = nil, bestPercentage: Double = 0.5, soonest: Date = Date(), latest: Date? = nil, isOwned: Bool = false, buyNotifications: Bool = true) {
        self.id = UUID().uuidString
        self._symbol = ticker.uppercased()
        self.isOwned = isOwned
        self.doNotify = buyNotifications
        self.annualized = 0.0
        self.scenarios = PositionScenarios()
    }
    
    convenience init() {
        self.init(ticker: "")
    }
    
    convenience init(best: Double = 0.0, worst: Double? = nil, latestPrice: Double, bid: Double, ask: Double, soonest: Date, latest: Date, bestPercentage: Double = 0.5)  {
        self.init()
        self.equity = Equity(latestPrice: latestPrice, bid: bid, ask: ask)
        self.annualized = 0.0
        self.scenarios = PositionScenarios()
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self._symbol = try container.decode(String.self, forKey: ._symbol)
            self.isOwned = try container.decode(Bool.self, forKey: .isOwned)
            self.doNotify = try container.decode(Bool.self, forKey: .doNotify)
            self.annualized = (try? container.decode(Double.self, forKey: .annualized)) ?? 0.0
            self.scenarios = (try? container.decode(PositionScenarios.self, forKey: .scenarios)) ?? PositionScenarios()
        } catch {
            Log.error("Failed to decode: \(error)")
            throw error
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
            try container.encode(_symbol, forKey: ._symbol)
            try container.encode(isOwned, forKey: .isOwned)
            try container.encode(doNotify, forKey: .doNotify)
            try container.encode(annualized, forKey: .annualized)
            try container.encode(scenarios, forKey: .scenarios)
        } catch {
            Log.error("Failed to encode: \(error)")
            throw error
        }
    }
    
    func annualizedReturnFor(_ spread: Spread) -> AnnualizedReturn {
        switch spread {
        case .ask:
            return AnnualizedReturn(symbol: symbol, price: askPrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .bid:
            return AnnualizedReturn(symbol: symbol, price: bidPrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .mid:
            return AnnualizedReturn(symbol: symbol, price: midPoint, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .purchasePrice:
            return AnnualizedReturn(symbol: symbol, price: purchasePrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
       }
    }
    
    func priceString(_ spread: Spread)->  String {
        var price: Double?
        switch spread {
        case .ask:
            price = askPrice
        case .bid:
            price = bidPrice
        case .mid:
            price = midPoint
        case .purchasePrice:
           price = purchasePrice
       }
        guard let price = price else { return "n/a" }
        return "$\(price.formatToDecimalPlaces())"
    }
    
    
    func lastUpdatedString(_ spread: Spread)->  String {
        var date: Date?
        switch spread {
        case .ask:
            date = equity?.lastUpdateDate
        case .bid:
            date = equity?.lastUpdateDate
        case .mid:
            date = equity?.lastUpdateDate
        case .purchasePrice:
            date = equity?.lastTradeDate
        }
        guard let date = date else { return "n/a" }
        return date.toUniqueTimeDayOrDate()
    }
}
