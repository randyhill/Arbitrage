//
//  Quote.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/29/21.
//

import SwiftUI

//struct PriceTime {
//    let price: Double
//    let time: Date
//}

struct Quote: Hashable, Codable, Identifiable {
    let id: String
    let symbol: String
    let companyName: String
    let latestPrice: Double
    let latestPriceTime: Date
    let bid: Double?
    let ask: Double?
    let bidAskUpdated: Date?
    let volume: Int?
    let updated: Date
    
    // Delayed fields
    let delayedPrice: Double?
    let delayedPriceTime: Date?
    let high: Double?
    let low: Double?
    
//    var lastTrade: Double {
//        if let delayedPrice = delayedPrice, let delayedPriceTime =
//    }
//
    var lastUpdated: Date {
        if let bidAskUpdated = bidAskUpdated {
            if bidAskUpdated > latestPriceTime {
                return bidAskUpdated
            }
        }
        return latestPriceTime
    }
    
    var lastTraded: Date {
        return latestPriceTime
    }

    init() {
        id = UUID().uuidString
        symbol = ""
        companyName = ""
        latestPrice = 0
        latestPriceTime = Date()
        delayedPrice = 0
        delayedPriceTime = Date()
        high = 0
        low = 0
        volume = 0
        updated = Date()
        bid = nil
        ask = nil
        bidAskUpdated = nil
    }
    
    init(_ quote: IEXQuote, delayed: IEXQuoteDelayed) {
        id = UUID().uuidString
        symbol = quote.symbol
        companyName = quote.companyName
        latestPrice = quote.latestPrice
        latestPriceTime = quote.lastTradeDate
        bid = quote.bid
        ask = quote.ask
        bidAskUpdated = quote.iexUpdateDate
        volume = quote.volume
        updated = quote.lastUpdateDate
        delayedPrice = delayed.delayedPrice
        delayedPriceTime = delayed.priceTime
        high = delayed.high
        low = delayed.low
    }
    
    init(_ quote: IEXQuote) {
        id = UUID().uuidString
        symbol = quote.symbol
        companyName = quote.companyName
        latestPrice = quote.latestPrice
        latestPriceTime = quote.lastTradeDate
        bid = quote.bid
        ask = quote.ask
        bidAskUpdated = quote.iexUpdateDate
        volume = quote.volume
        updated = quote.lastUpdateDate
        delayedPrice = nil
        delayedPriceTime = nil
        high = nil
        low = nil
    }
    
    init(latestPrice: Double, bid: Double?, ask: Double?)  {
        id = UUID().uuidString
        symbol = ""
        companyName = ""
        latestPriceTime = Date()
        delayedPrice = 0
        delayedPriceTime = Date()
        high = 0
        low = 0
        volume = 0
        updated = Date()
        bidAskUpdated = nil
        self.latestPrice = latestPrice
        self.bid = bid
        self.ask = ask
    }
}
