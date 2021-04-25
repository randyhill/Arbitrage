//
//  ScenarioEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioEditor: View {
    @Binding var scenario: Scenario
    var body: some View {
        Form {
            Text("Exit Scenario")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextFieldActive(title: "Payout", placeholder: "0.0", disableAutocorrection: true, text: $scenario.payoutString)
                .frame(height: 64)
            DatePicker("End Date", selection: $scenario.endDate, displayedComponents: .date)
                .frame(height: 64)
//            .frame(width: 124, alignment: .trailing)
//            .onChange(of: $scenario.endDate, perform: { newDate in

        }
    }
}

struct ScenarioEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioEditor(scenario: .constant(Scenario()))
    }
}
