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
    var priceType: Position.PriceType
    let font = Font.footnote
    
    var body: some View {
        HStack {
            let ar = position.annualizedReturnFor(priceType)
            let lastUpdated = position.lastUpdatedString(priceType)
            let price = position.priceString(priceType)
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
        PriceReturnRow(title: "Price", position: Database.testPosition, priceType: .bid)
    }
}
