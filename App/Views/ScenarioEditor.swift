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
    @State var percentage = 0.0
    var position: Position

    var body: some View {
        Form {
            Text("Exit Scenario")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextFieldActive(title: "Payout", placeholder: "0.0", disableAutocorrection: true, activate: true, text: $scenario.payoutString)
                .keyboardType(.decimalPad)
                .frame(height: 64)
            DatePicker("End Date", selection: $scenario.endDate, displayedComponents: .date)
                .frame(height: 64)
            HStack {
                let percentString = Int(percentage*100).formatted
                Text(percentString + "%")
                Slider(value: $percentage, in: 0...1)

            }
        }
        .onAppear() {
            percentage = scenario.percentage
        }
        .onDisappear() {
            scenario.percentage = percentage
            db.lastScenario = scenario
        }
    }
}

struct ScenarioEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioEditor(scenario: .constant(Scenario()), position: Database.testPosition)
    }
}
