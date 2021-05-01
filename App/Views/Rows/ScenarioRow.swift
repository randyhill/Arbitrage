//
//  ScenarioRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioRow: View {
    @Binding var scenario: Scenario
    var position: Position
    
    var body: some View {
        NavigationLink(
           destination:
            ScenarioEditor(scenario: scenario, position: position),
           label: {
            HStack {
                Text("Payout:")
                Text(scenario.payout.currency)
                Text("Days: \(scenario.days)")
                Text("\(scenario.percentString)")
            }
        })
    }
}

struct ScenarioRow_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioRow(scenario: .constant(Scenario(payout: 77, date: Date().add(years:1))), position: Database.testPosition)
    }
}
