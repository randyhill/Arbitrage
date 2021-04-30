//
//  Scenario.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import Foundation

class Scenario: Identifiable, Codable {
    let id: String
    var payout: Double
    var endDate: Date
    var percentage: Double
    
    var payoutString: String = ""
    {
        didSet {
             if payoutString.count == 0 {
                payout = 0.0
            } else if let newPayout = Double(payoutString) {
                payout = newPayout
            }
        }
    }
    
    var averagePayout: Double {
        return percentage * payout
    }
    
    var days: Int {
        let now = Date()
        return now.daysUntil(endDate)
    }
    
    var averageDays: Double {
        return Double(days) * percentage
    }
    
    var copy: Scenario {
        return Scenario(payout: payout, date: endDate, percentage: percentage)
    }
    
    init(payout: Double = 2.0, date: Date = Date(), percentage: Double = 0.5) {
        self.id = UUID().uuidString
        self.payout = payout
        self.payoutString = payout.stockPrice
        self.endDate = date
        self.percentage = percentage
    }
}

