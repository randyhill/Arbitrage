//
//  StockInfoRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct StockInfoPanel: View {
    var position: Position
    let font = Font.callout

    var body: some View {
        Text(position.companyName)
        PriceReturnRow(title: "Price:", position: position, spread: .purchasePrice)
        PriceReturnRow(title: "Bid:",  position: position, spread: .purchasePrice)
        PriceReturnRow(title: "Ask:",  position: position, spread: .purchasePrice)
        HStack {
            Text("Exit:")
                .font(font)
                .fontWeight(.bold)
                .frame(width: 50, alignment: .trailing)
            Text("$\(position.exitPrice.stockPrice)")
                .font(font)
                .frame(width: 120, alignment: .leading)
            Text("Days:")
                .font(font)
                .fontWeight(.bold)
                .frame(width: 80, alignment: .trailing)
            Text("\(position.periodDays)")
                .font(font)
                .frame(width: 120, alignment: .leading)
        }
     }
}

struct StockInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StockInfoPanel(position: Database.testPosition)
    }
}
