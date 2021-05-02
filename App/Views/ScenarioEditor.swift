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
    @State private var percentString = ""
    var position: Position

    var body: some View {
        Form {
            Text("Exit Scenario")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextFieldActive(title: "Payout", placeholder: "0.0", disableAutocorrection: true, activate: true, text: $payoutString)
                .onChange(of: payoutString, perform: { value in
                    scenario.setPayout(value)
                })
                .keyboardType(.decimalPad)
                .frame(height: 64)

            VStack {
                DatePicker("End Date", selection: $scenario.endDate, displayedComponents: .date)
                    .frame(height: 64)
            }
            PercentSlider(percentage: $percentage, percentString: "", range: 0...1.0, onChange: nil)
                .onChange(of: percentage, perform: { value in
                    let intValue = Int(value*100)
                    scenario.percentage = Double(intValue)/100
                    position.scenarios.recalcOtherPercentages(scenario)
            })
        }
        .onAppear() {
            percentage = scenario.percentage
            percentString = Int(percentage*100).formatted
            payoutString = "\(scenario.payout.stockPrice)"
        }
        .onDisappear() {
            // Remember so we can default to these values next scenario
            db.lastScenario = scenario
        }
    }
}

struct ScenarioEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioEditor(scenario: Scenario(), position: Database.testPosition)
    }
}
