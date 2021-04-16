//
//  Comments.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct Equity: Hashable, Codable, Identifiable {
    let id = UUID()
    let symbol: String
    let companyName: String
    let latestPrice: Double
    let volume: Int?
    let primaryExchange: String
    let marketCap: Int
    let peRatio: Double
    let lastTradeTime: Int
    let latestUpdate: Int
    private let iexLastUpdated: Int?
    private let iexBidPrice: Double
    private let iexBidSize: Double
    private let iexAskPrice: Double
    private let iexAskSize: Double
    
    var ask: Double {
        return iexAskPrice
    }
    
    var bid: Double {
        return iexBidPrice
    }
    
    var lastTradeDate: Date {
        return Date.fromInternetEpoch(lastTradeTime)
    }
    
    var lastUpdateDate: Date {
        return Date.fromInternetEpoch(latestUpdate)
    }
    
    var iexUpdateDate: Date {
        return Date.fromInternetEpoch(iexLastUpdated ?? 0)
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
    
    init() {
        symbol = ""
        companyName = ""
        latestPrice = 0.0
        volume = 0
        primaryExchange = ""
        marketCap = 0
        peRatio = 0.0
        lastTradeTime = 0
        latestUpdate = 0
        iexLastUpdated = 0
        iexBidSize = 0
        iexBidPrice = 0
        iexAskPrice = 0
        iexAskSize = 0
    }
}
