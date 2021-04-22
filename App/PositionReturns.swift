//
//  PositionReturns.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct PositionReturns: View {
    @Binding var position: Position
    private let textPadding: CGFloat = 1

    var body: some View {
        VStack(alignment: .trailing) {
            AnnualizedRow(position: $position, priceType: .ask)
                .padding(EdgeInsets(top: textPadding, leading: textPadding, bottom: textPadding, trailing: textPadding))
            if position.isOwned {
                AnnualizedRow(position: $position, priceType: .bid)
                    .padding(EdgeInsets(top: textPadding, leading: textPadding, bottom: textPadding, trailing: textPadding))
            }
         }
    }
}

struct PositionReturns_Previews: PreviewProvider {
    static var previews: some View {
        PositionReturns(position: .constant(Database.testPosition))
    }
}
