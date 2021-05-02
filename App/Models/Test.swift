//
//  TestSingleton.swift
//  Arbitrage
//
//  Created by Randy Hill on 5/1/21.
//

import Foundation

class Test {
    static var addDataToQuotes = false
    
    // If testing flag is turned on, return a different percentage of this value
    static func byPercent(startValue: Double, percent: Double) -> Double? {
        if addDataToQuotes {
            return startValue * percent
        }
        return nil
    }
    
    static func randomPercent(startValue: Double, range: Range<Double> = 0.8..<1.2) -> Double? {
        if addDataToQuotes {
            let percent = Double.random(in: range)
            return startValue * percent
        }
        return nil
    }
}


extension Double {
    var test_bid: Double? {
        if Test.addDataToQuotes {
            return self * 0.9
        }
        return nil
    }
}
