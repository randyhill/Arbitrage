//
//  ScenarioEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioEditor: View {
    @EnvironmentObject var db: Database
    @Binding var scenario: Scenario
    
    var body: some View {
        Form {
            Text("Exit Scenario")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextFieldActive(title: "Payout", placeholder: "0.0", disableAutocorrection: true, activate: true, text: $scenario.payoutString)
                .keyboardType(.numberPad)
                .frame(height: 64)
            DatePicker("End Date", selection: $scenario.endDate, displayedComponents: .date)
                .frame(height: 64)
        }
        .onDisappear() {
            db.lastScenario = scenario
        }
    }
}

struct ScenarioEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioEditor(scenario: .constant(Scenario()))
    }
}
