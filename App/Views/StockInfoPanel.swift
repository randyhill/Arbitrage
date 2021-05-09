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
    @Binding var exitPrice: Double
    @Binding var periodDays: Int
    let font = Font.footnote

    var body: some View {
        VStack(alignment: .leading, content: {
            Text(quote.companyName)
            Divider()
            PriceReturnRow(title: "Price:", quote: quote, priceType: .last, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
                if quote.bidPrice != nil {
                Divider()
                PriceReturnRow(title: "Bid:",  quote: quote, priceType: .bid, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            }
            if quote.midPoint != nil {
                Divider()
                PriceReturnRow(title: "Mid:",  quote: quote, priceType: .mid, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
             }
            if quote.askPrice != nil {
                Divider()
                PriceReturnRow(title: "Ask:",  quote: quote, priceType: .ask, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            }
            if quote.low != nil {
                Divider()
                PriceReturnRow(title: "Low:",  quote: quote, priceType: .low, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            }
            if quote.high != nil {
                Divider()
                PriceReturnRow(title: "High:",  quote: quote, priceType: .high, isOwned: isOwned, exitPrice: exitPrice, periodDays: periodDays)
            }

        })
    }
}

struct StockInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StockInfoPanel(quote: Database.testPosition.quote!, isOwned: true, exitPrice: .constant(22), periodDays: .constant(40))
    }
}
