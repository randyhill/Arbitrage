//
//  ScenarioRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioRow: View {
    @ObservedObject var scenario: Scenario
    var position: Position
    
    private let font = Font.footnote

    var body: some View {
        NavigationLink(
           destination:
                ScenarioEditor(scenario: scenario, position: position),
           label: {
            HStack {
                Text("Payout:")
                    .font(font)
                    .fontWeight(.bold)
                Text(scenario.payout.currency)
                    .font(font)
                Text("Days: \(scenario.days)")
                    .font(font)
               Text("\(scenario.percentString)")
                    .font(font)
                .font(font)
                .fontWeight(.bold)
            }
            .debug {
                Log.console("Scenario: \(scenario.percentage) for: \(position.companyName) ")
            }
        })
    }
}

struct ScenarioRow_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioRow(scenario: (Scenario(payout: 77, date: Date().add(years:1))), position: Database.testPosition)
    }
}
