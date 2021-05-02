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
    enum PriceType {
        case bid, ask, mid, purchase, high, low, last
    }
    
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
    
    var midPoint: Double? {
        if let ask = ask, let bid = bid {
            return (ask + bid)/2
        }
        return nil
    }
    
    var purchasePrice: Double? {
        if let ask = ask {
            return ask
        }
        if let mid = midPoint {
            return mid
        }
        if let bid = bid {
            return bid
        }
        return lastTradePrice
    }
    
    var askPrice: Double? {
        if let ask = ask, ask > 0 {
            return ask
        }
        return nil
    }
    
    var bidPrice: Double? {
        if let bid = bid, bid > 0 {
            return bid
        }
        return nil
    }

    var priceString: String {
        guard let price = purchasePrice else { return "n/a" }
        return "$\(price.formatToDecimalPlaces())"
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
        bid = quote.bid ?? Test.randomPercent(startValue: lastQuoteTime.price, range: 0.7..<1.0)
        ask = quote.ask ?? Test.randomPercent(startValue: lastQuoteTime.price, range: 1..<1.3)
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
        bid = quote.bid ?? Test.randomPercent(startValue: quote.lastTradePrice, range: 0.7..<1.0)
        ask = quote.ask ?? Test.randomPercent(startValue: quote.lastTradePrice, range: 1..<1.3)
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
    
    func annualizedReturnFor(_ priceType: PriceType, isOwned: Bool, exitPrice: Double, periodDays: Int) -> AnnualizedReturn {
        switch priceType {
        case .ask:
            return AnnualizedReturn(symbol: symbol, price: ask, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .bid:
            return AnnualizedReturn(symbol: symbol, price: bid, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .mid:
            return AnnualizedReturn(symbol: symbol, price: midPoint, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .purchase:
            return AnnualizedReturn(symbol: symbol, price: purchasePrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .low:
            return AnnualizedReturn(symbol: symbol, price: low, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
       case .high:
            return AnnualizedReturn(symbol: symbol, price: high, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
        case .last:
            return AnnualizedReturn(symbol: symbol, price: lastTradePrice, exitPrice: exitPrice, days: periodDays, isOwned: isOwned)
       }
    }
    
    func lastUpdatedString(_ priceType: PriceType)->  String {
        var date: Date?
        switch priceType {
        case .ask, .bid, .mid, .purchase, .last:
            date = lastTradeDate
        case .low:
            date = lowPriceTime.timeStamp
        case .high:
            date = highPriceTime.timeStamp
        }
        guard let date = date else { return "n/a" }
        return date.toUniqueTimeDayOrDate()
    }
    
    func priceString(_ priceType: PriceType)->  String {
        var price: Double?
        switch priceType {
        case .ask:
            price = ask
        case .bid:
            price = bid
        case .mid:
            price = midPoint
        case .purchase:
           price = purchasePrice
        case .low:
            price = low
        case .high:
            price = high
        case .last:
            price = lastTradePrice
       }
        guard let price = price else { return "n/a" }
        return "$\(price.formatToDecimalPlaces())"
    }
}
