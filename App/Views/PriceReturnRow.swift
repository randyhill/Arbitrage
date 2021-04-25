//
//  PriceReturnRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct PriceReturnRow: View {
    var title: String
    var position: Position
    var spread: Position.Spread
    let font = Font.callout
    
    var body: some View {
        HStack {
            let ar = position.annualizedReturnFor(spread)
            let lastUpdated = position.lastUpdatedString(spread)
            let price = position.priceString(spread)
            Text(title)
                .font(font)
                .fontWeight(.semibold)
                .frame(width: 54, alignment: .leading)
            Text(price)
                .font(font)
                .frame(width: 72, alignment: .leading)
            Text("A/R: ")
                .font(.caption2)
                .fontWeight(.bold)
                .frame(width: 30, alignment: .trailing)
            Text(ar.annualizedString)
                .font(font)
                .frame(width: 50, alignment: .leading)
            Text(lastUpdated)
                .font(.caption2)
                .frame(width: 80, alignment: .trailing)
        }
    }
}

struct PriceReturnRow_Previews: PreviewProvider {
    static var previews: some View {
        PriceReturnRow(title: "Bid", position: Database.testPosition, spread: .bid)
    }
}
