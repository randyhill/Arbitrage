//
//  ScenarioEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioEditor: View {
    @EnvironmentObject var db: Database
    @ObservedObject var scenario: Scenario
    @State var percentage = 0.0
    @State var payoutString = ""
    var position: Position

    var body: some View {
        Form {
            Text("Exit Scenario")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextFieldActive(title: "Payout", placeholder: "0.0", disableAutocorrection: true, activate: true, text: $payoutString, onChangeCallback: { newValue in
                scenario.setPayout(newValue)
            })
                .keyboardType(.decimalPad)
                .frame(height: 64)
            DatePicker("End Date", selection: $scenario.endDate, displayedComponents: .date)
                .frame(height: 64)
            HStack {
                let percentString = Int(percentage*100).formatted
                Text(percentString + "%")
                Slider(value: $percentage, in: 0...1)
                    .onChange(of: percentage, perform: { value in
                        let intValue = Int(value*100)
                        scenario.percentage = Double(intValue)/100
                        position.scenarios.recalcPercentages(scenario)
                    })

            }
        }
        .onAppear() {
            percentage = scenario.percentage
            payoutString = "\(scenario.payout.stockPrice)"
        }
        .onDisappear() {
            scenario.percentage = percentage
            db.lastScenario = scenario
        }
    }
}

struct ScenarioEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioEditor(scenario: Scenario(), position: Database.testPosition)
    }
}
