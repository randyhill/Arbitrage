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
    @State private var latest = Date()
    @State private var averageDays = 0
    @State private var scenarios = [Scenario]()
    @State private var exitPrice: Double = 0
    @State private var exitDays: Int = 0
    @State private var exitDate = Date()
  
    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", activate: activateTickerField, text: $position.symbol)
            StockInfoPanel(position: position)
            ExitValuesRow(exitPrice: $exitPrice, periodDays: $exitDays, endDate: $exitDate)
            ScenarioTitleRow(position: $position)
                .environmentObject(db)

            List {
                ForEach(scenarios.indices, id: \.self) { index in
                     ScenarioRow(scenario: $scenarios[index])
                        .environmentObject(db)
                }
            }
            HStack {
                Checkbox(isChecked: $position.isOwned, title: "Owned") { (changed) in
                 }
                Spacer()
                Checkbox(isChecked: $position.doNotify, title: "Notifications") { (changed) in
                }
            }.padding()
        }
        .onAppear() {
            self.scenarios = position.scenarios.list
            self.averageDays = position.periodDays
            self.exitPrice = position.exitPrice
            self.exitDays = position.periodDays
            self.exitDate = position.endDate
        }
        .onDisappear() {
            position.scenarios.replace(scenarios)
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
