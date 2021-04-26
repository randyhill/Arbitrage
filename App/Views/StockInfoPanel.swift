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
        Text(position.companyName)
        PriceReturnRow(title: "Price:", position: position, spread: .purchasePrice)
        PriceReturnRow(title: "Bid:",  position: position, spread: .purchasePrice)
        PriceReturnRow(title: "Ask:",  position: position, spread: .purchasePrice)
     }
}

struct StockInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        StockInfoPanel(position: Database.testPosition)
    }
}
