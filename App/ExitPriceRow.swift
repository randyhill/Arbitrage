//
//  ExitPriceRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/18/21.
//

import SwiftUI

struct ExitPriceRow: View {
    var position: Position
    var body: some View {
        HStack {
            Text("Exit:")
                .font(.headline)
                .fontWeight(.bold)
            Text("\(position.exitPrice.currency)")
                .font(.headline)
                .fontWeight(.regular)
        }
    }
}

struct ExitPriceRow_Previews: PreviewProvider {
    static var previews: some View {
        ExitPriceRow(position: Database.testPosition)
    }
}
