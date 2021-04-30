//
//  PositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/12/21.
//

import SwiftUI

struct PositionEditor: View {
    @State var position: Position
    @Binding var scenarios: ScenarioList
    var activateTickerField = false
    @EnvironmentObject var db: Database
    
    // Private state
    @State private var symbol = ""
    @State private var latest = Date()
    @State private var averageDays = 0
    @State private var exitPrice: Double = 0
    @State private var exitDays: Int = 0
    @State private var exitDate = Date()
   
    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", activate: activateTickerField, text: $symbol, onChangeCallback: { value in
                    if value.count > 0 {
                        symbol = value.capitalized
                        db.getSymbolQuote(value) { quote in
                            position.quote = quote
                        }
                    }
                })
            StockInfoPanel(position: position)
            ExitValuesRow(exitPrice: $exitPrice, periodDays: $exitDays, endDate: $exitDate)
            ScenarioTitleRow(position: $position)
                .environmentObject(db)

            List {
                ForEach(scenarios.list.indices, id: \.self) { index in
                    ScenarioRow(scenario: $scenarios.list[index], position: position)
                        .environmentObject(db)
                }
                .onDelete(perform: { indexSet in
                    scenarios.deleteAt(indexSet)
                })
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
            symbol = position.symbol
            averageDays = position.periodDays
            exitPrice = position.exitPrice
            exitDays = position.periodDays
            exitDate = position.endDate
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
        PositionEditor(position: Database.testPosition, scenarios: .constant(Database.testPosition.scenarios))
            .environmentObject(Database())
    }
}
