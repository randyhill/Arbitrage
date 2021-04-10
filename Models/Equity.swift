//
//  Comments.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct Equity: Codable, Identifiable {
    let id = UUID()
    let symbol: String
    let companyName: String
    let latestPrice: Double
    let volume: Int?
    let primaryExchange: String
    let marketCap: Int
    let peRatio: Double
    private let lastTradeTime: Int
    private let latestUpdate: Int
    private let iexLastUpdated: Int
    
    var lastTradeDate: Date {
        return Date.fromInternetEpoch(lastTradeTime)
    }
    
    var lastUpdateDate: Date {
        return Date.fromInternetEpoch(latestUpdate)
    }
    
    var iexUpdateDate: Date {
        return Date.fromInternetEpoch(iexLastUpdated)
    }
    
    var title: String {
        return "Ticker: \(symbol)\nName: \(companyName)\nPrice: \(latestPrice)"
    }
    
    var details: String {
        let lastTradeString = lastTradeDate.toUniqueTimeDayOrDate()
        return "Volume: \(Int.shortFormat(volume))\nLast Trade: \(lastTradeString)\nMarket Cap: \(marketCap.shortFormatted)"
    }
    
    var info: String {
        return "Updated: \(lastUpdateDate.toUniqueTimeDayOrDate())\nIEX Update: \(iexUpdateDate.toUniqueTimeDayOrDate())\nExchange: \(primaryExchange)"
    }
}
