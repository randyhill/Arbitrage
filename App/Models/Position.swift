//
//  Position.swift
//  Arbitrage (iOS)
//
//  Created by Randy Hill on 4/9/21.
//

import SwiftUI

let annualizedReturnGoal: Double = 0.50 // 50%

class Position: Identifiable, Codable {
//    enum PriceType {
//        case bid, ask, mid, purchase, high, low, last
//    }
    
    enum CodingKeys: CodingKey {
        case id, _symbol, bestCase, worstCase, bestPercentage, soonest, latest, isOwned, doNotify, annualized, scenarios
    }
    
    let id: String
    var _symbol: String
    @Published var quote: Quote?
    @Published var isOwned: Bool
    var annualized: Double
    var doNotify: Bool                  // Ignore this position for alerts
    var scenarios: ScenarioList
    
    var symbol: String {
        get {
            return _symbol
        }
        set {
            _symbol = newValue.uppercased()
        }
    }
    
    var exitPrice: Double {
         return scenarios.averagePayout
    }
    
    var totalReturn: Double? {
        guard let price = quote?.purchasePrice else {
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
        guard let price = quote?.purchasePrice else {
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
        return quote?.companyName ?? "No Data"
    }
    
    init(symbol: String, best: Double = 0.0, worst: Double? = nil, bestPercentage: Double = 0.5, soonest: Date = Date(), latest: Date? = nil, isOwned: Bool = false, buyNotifications: Bool = true) {
        self.id = UUID().uuidString
        self._symbol = symbol.uppercased()
        self.isOwned = isOwned
        self.doNotify = buyNotifications
        self.annualized = 0.0
        self.scenarios = ScenarioList()
    }
    
    convenience init() {
        self.init(symbol: "")
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self._symbol = try container.decode(String.self, forKey: ._symbol)
            self.isOwned = try container.decode(Bool.self, forKey: .isOwned)
            self.doNotify = try container.decode(Bool.self, forKey: .doNotify)
            self.annualized = (try? container.decode(Double.self, forKey: .annualized)) ?? 0.0
            self.scenarios = (try? container.decode(ScenarioList.self, forKey: .scenarios)) ?? ScenarioList()
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
    
    func annualizedReturnFor(_ priceType: Quote.PriceType) -> AnnualizedReturn {
        guard let quote = quote else { return AnnualizedReturn() }
        return quote.annualizedReturnFor(priceType, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
    }
}
