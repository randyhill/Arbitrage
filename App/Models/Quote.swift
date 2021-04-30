//
//  Quote.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/29/21.
//

import SwiftUI

struct PriceTime: Hashable, Codable {
    let price: Double
    let time: Int
    var timeStamp: Date {
        return Date.fromInternetEpoch(time)
    }
    
    // If arguments nil, return oldest possible time for compaarisons
    static func create(price: Double?, time: Int?) -> PriceTime {
        if let price = price, let time = time {
            return PriceTime(price: price, time: time)
        }
        return PriceTime(price: 0, time: 0)
    }
}

struct Quote: Hashable, Codable, Identifiable {
    let id: String
    let symbol: String
    let companyName: String
    let lastTrade: PriceTime
    let bid: Double?
    let ask: Double?
    let volume: Int?
    let highPriceTime: PriceTime
    let lowPriceTime: PriceTime
    
    var lastTradePrice: Double {
        return lastTrade.price
    }
    
    var lastTradeDate: Date {
        return lastTrade.timeStamp
    }

    var high: Double {
        return highPriceTime.price
    }
    
    var low: Double {
        return lowPriceTime.price
    }

    init() {
        id = UUID().uuidString
        symbol = ""
        companyName = ""
        lastTrade = PriceTime(price: 0, time: 0)
        highPriceTime = PriceTime.create(price: 0, time: 0)
        lowPriceTime = PriceTime.create(price: 0, time: 0)
        volume = 0
        bid = nil
        ask = nil
    }
    
    init(_ quote: IEXQuote, delayed: IEXQuoteDelayed) {
        id = UUID().uuidString
        symbol = quote.symbol
        companyName = quote.companyName
        let lastQuoteTime = quote.lastPriceTime
        let delayedQuoteTime = PriceTime(price: delayed.delayedPrice, time: delayed.delayedPriceTime)
        if delayedQuoteTime.time > lastQuoteTime.time {
            lastTrade = delayedQuoteTime
        } else {
            lastTrade = lastQuoteTime
        }
        bid = quote.bid
        ask = quote.ask
        volume = delayed.totalVolume > quote.volume ? delayed.totalVolume : quote.volume
        let hpt = quote.highPriceTime
        highPriceTime = hpt.time > delayed.delayedPriceTime ? hpt : PriceTime(price: delayed.high, time: delayed.delayedPriceTime)
        let lpt = quote.lowPriceTime
        lowPriceTime = lpt.time > delayed.delayedPriceTime ? lpt : PriceTime(price: delayed.low, time: delayed.delayedPriceTime)
    }
    
    init(_ quote: IEXQuote) {
        id = UUID().uuidString
        symbol = quote.symbol
        companyName = quote.companyName
        lastTrade = quote.lastPriceTime
        bid = quote.bid
        ask = quote.ask
        volume = quote.volume
        highPriceTime = quote.highPriceTime
        lowPriceTime = quote.lowPriceTime
    }
    
    // Used to create test versions
    init(latestPrice: Double, bid: Double?, ask: Double?)  {
        id = UUID().uuidString
        symbol = ""
        companyName = ""
        lastTrade = PriceTime(price: latestPrice, time: Int(Date().timeIntervalSince1970))
        highPriceTime = PriceTime.create(price: 0, time: 0)
        lowPriceTime = PriceTime.create(price: 0, time: 0)
        volume = 0
        self.bid = bid
        self.ask = ask
    }
}
