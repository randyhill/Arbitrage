//
//  PositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/12/21.
//

import SwiftUI

struct PositionEditor: View {
    @Binding var position: Position
    var activateTickerField = false
    @EnvironmentObject var db: Database
    
    // Private state
    @State private var symbol = ""
    @State private var latest = Date()
    @State private var averageDays = 0
    @State private var showScenarioEditor = false
    @State private var newScenario = Scenario()

    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", activate: activateTickerField, text: $symbol)
            StockInfoPanel(position: position)
            HStack {
                Text("Exit Scenarios")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Button("Add...") {
                    newScenario = Scenario()
                    position.scenarios.add(newScenario)
                    showScenarioEditor = true
                }
            }
            .sheet(isPresented: $showScenarioEditor, content: {
                ScenarioEditor(scenario: $newScenario)
            })
            .frame(height: 54, alignment: .bottom)
            
            List {
                ForEach(position.scenarios.list) { scenario in
                    ScenarioRow(scenario: scenario)
                }
            }
            HStack {
                Checkbox(isChecked: $position.isOwned, title: "Owned") { (changed) in
                    print("IsOwned: \(changed)")
                }
                Spacer()
                Checkbox(isChecked: $position.doNotify, title: "Notifications") { (changed) in
                    print("Notifications: \(changed)")
                }
            }.padding()
        }
        .onAppear() {
            averageDays = position.periodDays
            symbol = position.symbol
            showScenarioEditor = false
        }
        .onDisappear() {
            position.symbol = symbol
            db.save()
            db.refreshAllSymbols()
        }
    }
}

struct PositionEditor_Previews: PreviewProvider {
    static var previews: some View {
        PositionEditor(position: .constant(Database.testPosition))
            .environmentObject(Database())
    }
}
