//
//  AnnualizedReturn.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct AnnualizedReturn {
    let price: Double?
    let AR: Double?
    let bgColor: Color
    let textColor: Color
    let frameColor: Color
    
    var priceString: String {
        if let price = price {
            return "$" + price.formatToDecimalPlaces(min: 2, max: 3)
        }
        return "n/a"
    }
    
    var annualizedString: String {
        return String.toPercent(AR, maxPlaces: 0)
    }
    
    init(price: Double?, exitPrice: Double, days: Int, isOwned: Bool) {
        guard let price = price else {
            self.AR = nil
            self.price = nil
            bgColor = Color.gray
            textColor = Color.white
            frameColor = Color.black
            return
        }
        self.price = price
        let annualized = AnnualizedReturn.calc(sellAt: exitPrice, price: price, days: days)
        self.AR = annualized
        let colors = AnnualizedReturn.colors(annualized, isOwned: isOwned)
        self.bgColor = colors.background
        self.textColor = colors.text
        self.frameColor = colors.text == Color.white  ? Color.black : Color.white
    }
    
    static func colors(_ annualizedReturn: Double, isOwned: Bool) -> (text: Color, background: Color) {
        if annualizedReturn >= 0.5 {
            return (text: Color.white, background: Color.coolGreen)
        }
        if annualizedReturn >= 0.35 {
             return (text: Color.white, background: Color.coolBlue)
        }
        if isOwned {
            if annualizedReturn <= 0.10 {
                return (text: Color.white, background: Color.coolRed)
            }
            if annualizedReturn <= 0.20 {
                return (text: Color.white, background: Color.coolYellow)
            }
        }
        return (text: Color.black, background: Color.white)
    }
    
    static func returnCalc(sellAt: Double, price: Double) -> Double {
        return sellAt/price - 1
    }

    // Cap at 1,000% percent cause, come-on man.
    // Since we are using days instead of years there is a minor amount of imprecision since we ignore leap years
    static func calc(sellAt: Double, price: Double, days: Int) -> Double {
        let grossReturn = returnCalc(sellAt: sellAt, price: price)
        let negativeReturn = grossReturn < 0
        let years = Double(days)/364
        let annualized = (pow(1 + grossReturn, 1/years))
        if negativeReturn {
            if annualized > 10 {
                return -10
            }
            return -annualized
        } else {
            if annualized > 10 { return 10 }
            return annualized - 1
        }
    }
}
