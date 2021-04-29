//
//  Comments.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct IEXQuote: Codable {
    let symbol: String
    let companyName: String
    private let latestPrice: Double
    private let latestUpdate: Int                   // Last price change time, ie trade, in seconds
    let latestVolume: Int?                  // Includes pre-market
    let primaryExchange: String
    let delayedPrice: Double?               // For some reason delayed/odd lot isn't returned for some stocks, maybe after horus.
    let delayedPriceTime: Int?
    let oddLotDelayedPrice: Double?
    let oddLotDelayedPriceTime: Int?
    let lastTradeTime: Int                  // last market hours trade excluding the closing auction trade.
    private let iexLastUpdated: Int?        // Last update time of iexRealtimePrice, if -1 or 0, IEX has not quoted it in trading day.
    private let iexRealtimePrice: Double?   // Refers to the price of the last trade on IEX.
    private let iexRealtimeSize: Int?
    private let iexBidPrice: Double?
    private let iexBidSize: Double?
    private let iexAskPrice: Double?
    private let iexAskSize: Double?
    let high: Double?
    let highTime: Int?
    let low: Double?
    let lowTime: Int?

    
    var ask: Double? {
        return iexAskPrice
    }
    
    var bid: Double? {
        return iexBidPrice
    }
    
    var lastTradePrice: Double {
        return lastPriceTime.price
    }
    
    var lastTradeDate: Date {
        return lastPriceTime.timeStamp
    }
    
    var lastPriceTime: PriceTime {
        var priceTimes = [PriceTime.create(price: latestPrice, time: latestUpdate), PriceTime.create(price: delayedPrice, time: delayedPriceTime), PriceTime.create(price: iexRealtimePrice, time: iexLastUpdated), PriceTime.create(price: oddLotDelayedPrice, time: oddLotDelayedPriceTime)]
        priceTimes.sort { first, second in
            return first.time > second.time
        }
        return priceTimes.first!
    }
    
    var highPriceTime: PriceTime {
//        guard let high = high, let highTime = highTime else { return nil }
        return PriceTime.create(price: high, time: highTime)
    }
    
    var lowPriceTime: PriceTime {
//        guard let low = low, let lowTime = lowTime else { return nil }
        return PriceTime.create(price: low, time: lowTime)
    }

    var volume: Int {
        return latestVolume ?? 0
    }
    
    init() {
        symbol = ""
        companyName = ""
        latestPrice = 0.0
        latestVolume = 0
        primaryExchange = ""
        delayedPrice = 0
        delayedPriceTime = 0
        oddLotDelayedPrice = 0
        oddLotDelayedPriceTime = 0
        lastTradeTime = 0
        latestUpdate = 0
        iexLastUpdated = 0
        iexBidSize = 0
        iexBidPrice = 0
        iexAskPrice = 0
        iexAskSize = 0
        iexRealtimePrice = 0
        iexRealtimeSize = 0
        high = 0
        highTime = 0
        low = 0
        lowTime = 0
    }
    
    init(latestPrice: Double, bid: Double? = nil, ask: Double? = nil) {
        self.latestPrice = latestPrice
        self.iexBidPrice = bid
        self.iexAskPrice = ask
        symbol = "test"
        companyName = "testing"
        latestVolume = 0
        primaryExchange = "testing"
        delayedPrice = 0
        delayedPriceTime = 0
        oddLotDelayedPrice = 0
        oddLotDelayedPriceTime = 0
        lastTradeTime = 0
        latestUpdate = 0
        iexLastUpdated = 0
        iexBidSize = 0
        iexAskSize = 0
        iexRealtimePrice = 0
        iexRealtimeSize = 0
        high = 0
        highTime = 0
        low = 0
        lowTime = 0
    }
    
    init(_ symbol: String, latestPrice: Double, bid: Double? = nil, ask: Double? = nil) {
        self.latestPrice = latestPrice
        self.iexBidPrice = bid
        self.iexAskPrice = ask
        self.symbol = symbol
        companyName = "testing"
        latestVolume = 0
        primaryExchange = "testing"
        delayedPrice = 0
        delayedPriceTime = 0
        oddLotDelayedPrice = 0
        oddLotDelayedPriceTime = 0
        lastTradeTime = 0
        latestUpdate = 0
        iexLastUpdated = 0
        iexBidSize = 0
        iexAskSize = 0
        iexRealtimePrice = 0
        iexRealtimeSize = 0
        high = 0
        highTime = 0
        low = 0
        lowTime = 0
    }
}
