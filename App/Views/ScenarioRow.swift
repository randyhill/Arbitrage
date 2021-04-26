//
//  ScenarioRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioRow: View {
    @Binding var scenario: Scenario
    
    var body: some View {
        NavigationLink(
           destination:
               ScenarioEditor(scenario: $scenario),
           label: {
            HStack {
                Text("Payout:")
                Text(scenario.payout.currency)
                Text("Days: \(scenario.days)")
            }
        })
    }
}

struct ScenarioRow_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioRow(scenario: .constant(Scenario(payout: 77, date: Date().add(years:1))))
    }
}
