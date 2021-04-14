//
//  ContentView.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var db: Database
    @State var positions: [Position]
    private let textPadding: CGFloat = 0.5

    var body: some View {
        NavigationView {
            List(positions) { position in
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: PositionEditor(position: position),
                        label: {
                            Text(position.currentState)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                    })
                    Text(position.bestCaseDescription)
                        .font(.subheadline)
                        .padding(textPadding)
                    Text("\(position.worstCaseDescription)")
                        .font(.subheadline)
                        .padding(textPadding)
                    Text("Average Days: \(position.averageDays)")
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
            }
            .onAppear() {
//                positions = Database.shared.positions
            }.navigationTitle("Stocks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(positions: Database.testPositions)
            .environmentObject(Database.shared)
    }
}
