//
//  PositionView.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/14/21.
//

import SwiftUI

struct PositionView: View {
    @Binding var position: Position
    private let textPadding: CGFloat = 0.5

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(
                destination: PositionEditor(position: position),
                label: {
                    Text(position.currentState)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
            })
            if let equity = position.equity {
                Text("Bid: \(equity.bid)")
                    .font(.subheadline)
                    .padding(textPadding)
                Text("Ask: \(equity.ask)")
                    .font(.subheadline)
                    .padding(textPadding)
            }
            Text("Days: \(position.averageDays)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("50% Annualized Price: \(position.purchasePrice)")
                    .font(.subheadline)
                    .padding(textPadding)
            Text("Average Return: \(String.toPercent(position.totalReturn))")
                .font(.subheadline)
                .padding(textPadding)
            Text("Annualized Return: \(String.toPercent(position.annualizedReturn))")
                .font(.headline)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
        }
        .debug {
            Log.console("Position equity: \(String(describing: position.equity))")
        }
    }
}

struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        PositionView(position: .constant(Database.testPositions.first!))
    }
}
