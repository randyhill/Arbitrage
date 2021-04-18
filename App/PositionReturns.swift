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
            Text("Goal Price: \(position.goalPrice)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("Total Return: \(String.toPercent(position.totalReturn))")
                .font(.subheadline)
                .padding(textPadding)
            Text("Bid Return: \(String.toPercent(position.bidReturn))")
                .font(.headline)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .background(position.bidColor)
            Text("Ask Return: \(String.toPercent(position.askReturn))")
                .font(.headline)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .background(position.askColor)
        }
    }
}

struct PositionReturns_Previews: PreviewProvider {
    static var previews: some View {
        PositionReturns(position: .constant(Database.testPosition))
    }
}
