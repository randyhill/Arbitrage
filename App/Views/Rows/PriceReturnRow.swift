//
//  PriceReturnRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct PriceReturnRow: View {
    var title: String
    var quote: Quote
    var priceType: Quote.PriceType
    var isOwned: Bool
    var exitPrice: Double
    var periodDays: Int
    let font = Font.footnote
    
    var body: some View {
        HStack {
            let ar = quote.annualizedReturnFor(priceType, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            let lastUpdated = quote.lastUpdatedString(priceType)
            let price = quote.priceString(priceType)
            Text(title)
                .font(font)
                .fontWeight(.bold)
                .frame(width: 48, alignment: .trailing)
            Text(price)
                .font(font)
                .frame(width: 72, alignment: .leading)
            Text(ar.annualizedString)
                .font(font)
                .frame(width: 50, alignment: .leading)
            Text(lastUpdated)
                .font(.caption2)
                .frame(width: 120, alignment: .trailing)
        }
    }
}

struct PriceReturnRow_Previews: PreviewProvider {
    static var previews: some View {
        PriceReturnRow(title: "Price", quote: Database.testPosition.quote!, priceType: .bid, isOwned: true, exitPrice: 20.0, periodDays: 44)
    }
}
