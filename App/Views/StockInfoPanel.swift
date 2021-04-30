//
//  StockInfoRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct StockInfoPanel: View {
    var quote: Quote
    var isOwned: Bool
    var exitPrice: Double
    var periodDays: Int
    let font = Font.footnote

    var body: some View {
        VStack(alignment: .leading, content: {
            Text(quote.companyName)
            Divider()
            PriceReturnRow(title: "Price:", quote: quote, priceType: .last, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            Divider()
            if quote.bidPrice != nil {
                PriceReturnRow(title: "Bid:",  quote: quote, priceType: .bid, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
                Divider()
            }
            if quote.askPrice != nil {
                PriceReturnRow(title: "Ask:",  quote: quote, priceType: .ask, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
                Divider()
            }
            PriceReturnRow(title: "Low:",  quote: quote, priceType: .low, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            Divider()
            PriceReturnRow(title: "High:",  quote: quote, priceType: .high, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)

        })
    }
}

struct StockInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StockInfoPanel(quote: Database.testPosition.quote!, isOwned: true, exitPrice: 22, periodDays: 40)
    }
}
