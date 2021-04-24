//
//  AnnualizedReturn.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct AnnualizedReturn: Comparable {
    static func < (lhs: AnnualizedReturn, rhs: AnnualizedReturn) -> Bool {
        if let leftReturn = lhs.annualReturn {
            if let rightReturn = rhs.annualReturn {
                return leftReturn < rightReturn
            }
            return true
        }
        return false
    }
    
    enum State: Equatable {
        case buy, possibleBuy, neutral, possibleSale(Bool), sell(Bool)
        
        static func make(_ annualReturn: Double, isOwned: Bool) -> State {
            switch annualReturn {
            case 0.5...:
                return .buy
            case 0.35...:
                return .possibleBuy
            case ...0:
                return .sell(isOwned)
            case ..<0.2:
                return possibleSale(isOwned)
            default:
                return neutral
            }
        }
        
        var color: Color {
            switch self {
            case .buy:
                return Color.blue
            case .possibleBuy:
                return Color.lightBlue
            case .neutral:
                return Color.white
            case .possibleSale(let isOwned):
                if isOwned {
                    return Color.coolSalmon
                } else {
                    return Color.white
                }
            case .sell(let isOwned):
                if isOwned {
                    return Color.coolRed
                } else {
                    return Color.white
                }
            }
        }
        
        var textColor: Color {
            switch self {
            case .buy:
                return Color.white
            case .neutral, .possibleBuy, .possibleSale:
                return Color.black
            case .sell(let isOwned):
                if isOwned {
                    return Color.white
                } else {
                    return Color.black
                }
            }
       }
    }
    
    let price: Double?
    let annualReturn: Double?
    var bgColor: Color {
        return state.color
    }
    var textColor: Color {
        return state.textColor
    }
    var frameColor: Color {
        return Color.black
    }
    let state: State
    
    var priceString2: String {
        if let price = price {
            return price.stockPrice
        }
        return "n/a"
    }
    
    var annualizedString: String {
        return String.toPercent(annualReturn, maxPlaces: 0)
    }
    
    init(price: Double?, exitPrice: Double, days: Int, isOwned: Bool) {
        guard let price = price else {
            self.annualReturn = nil
            self.price = nil
            state = .neutral
            return
        }
        self.price = price
        let annualized = AnnualizedReturn.calc(sellAt: exitPrice, price: price, days: days)
        self.annualReturn = annualized
        self.state = State.make(annualized, isOwned: isOwned)
    }
    
    static func returnCalc(sellAt: Double, price: Double) -> Double {
        return sellAt/price - 1
    }

    // Cap at 1,000% percent cause, come-on man.
    // Since we are using days instead of years there is a minor amount of imprecision since we ignore leap years
    static func calc(sellAt: Double, price: Double, days: Int) -> Double {
        guard price > 0 else { return 0 }
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
