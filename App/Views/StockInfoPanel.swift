//
//  StockInfoRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct StockInfoPanel: View {
    var position: Position
    let font = Font.footnote

    var body: some View {
        VStack(alignment: .leading, content: {
            Text(position.companyName)
            Divider()
            PriceReturnRow(title: "Price:", position: position, priceType: .last)
            Divider()
            if position.bidPrice != nil {
                PriceReturnRow(title: "Bid:",  position: position, priceType: .bid)
                Divider()
            }
            if position.askPrice != nil {
                PriceReturnRow(title: "Ask:",  position: position, priceType: .ask)
                Divider()
            }
            PriceReturnRow(title: "Low:",  position: position, priceType: .low)
            Divider()
            PriceReturnRow(title: "High:",  position: position, priceType: .high)

        })
    }
}

struct StockInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StockInfoPanel(position: Database.testPosition)
    }
}
