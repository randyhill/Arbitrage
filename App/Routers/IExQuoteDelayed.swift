//
//  IExDelayedQuote.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/29/21.
//

import SwiftUI

struct IEXQuoteDelayed: Codable {
    let symbol: String
    let delayedPrice: Double
    let high: Double
    let low: Double
    let delayedSize: Int
    let delayedPriceTime: Int
    let totalVolume: Int
    let processedTime: Int
    
    var priceDate: Date {
        return Date.fromInternetEpoch(delayedPriceTime)
    }
    var processedAt: Date {
        return Date.fromInternetEpoch(processedTime)
    }
    
    init() {
        symbol = ""
        delayedPrice = 0
        high = 0
        low = 0
        delayedSize = 0
        delayedPriceTime = 0
        totalVolume = 0
        processedTime = 0
    }
}

