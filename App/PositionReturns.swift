//
//  PositionReturns.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct PositionReturns: View {
    @Binding var position: Position
    private let textPadding: CGFloat = 0.5

    var body: some View {
        VStack {
            if let bid = position.equity?.bid {
                Text("Bid: \(bid)")
                    .font(.subheadline)
                    .padding(textPadding)
            }
            if let ask = position.equity?.ask {
                Text("Ask: \(ask)")
                    .font(.subheadline)
                    .padding(textPadding)
            }
            Text("Days: \(position.periodDays)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("Best Case: \(position.bestCaseString)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("Worst Case: \(position.worstCaseString)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("Goal Price: \(position.goalPrice.equityPrice)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("Total Return: \(String.toPercent(position.totalReturn))")
                .font(.subheadline)
                .padding(textPadding)
            AnnualizedField(title: "Ask:", annualReturn: AnnualizedReturn(price: position.askPrice, exitPrice: position.outcome, days: position.periodDays, isOwned: position.isOwned))
            AnnualizedField(title: "Bid:", annualReturn: AnnualizedReturn(price: position.bidPrice, exitPrice: position.outcome, days: position.periodDays, isOwned: position.isOwned))
        }
    }
}

struct PositionReturns_Previews: PreviewProvider {
    static var previews: some View {
        PositionReturns(position: .constant(Database.testPosition))
    }
}
