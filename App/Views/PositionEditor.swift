//
//  PositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/12/21.
//

import SwiftUI

struct PositionEditor: View {
    @ObservedObject var position: Position
    @ObservedObject var scenarios: ScenarioList
    var activateTickerField = false
    @EnvironmentObject var db: Database
    
    // Private state
    @State private var symbol = ""
    @State private var quote: Quote? = nil
    @State private var isOwned: Bool = false
    @State private var exitPrice: Double = 0
    @State private var periodDays: Int = 0
    @State private var exitDate = Date()
   
    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", activate: activateTickerField, text: $symbol)
                .onChange(of: symbol, perform: { value in
                    if value.count > 0 {
                        db.getSymbolQuote(value) { quote in
                            self.quote = quote
                            position.quote = quote
                            let capped = value.capitalized
                            self.symbol = capped
                            position.symbol = capped
                        }
                    }
                })
            if let quote = quote {
                StockInfoPanel(quote: quote, isOwned: position.isOwned, exitPrice: $exitPrice, periodDays: $periodDays)
            }
            ExitValueRow(exitPrice: $exitPrice, periodDays: $periodDays, endDate: $exitDate)
            ScenarioTitleRow(position: position)
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
                Checkbox(isChecked: $isOwned, title: "Owned") { (changed) in
                    position.isOwned = changed
                 }
                Spacer()
                Checkbox(isChecked: $position.doNotify, title: "Notifications") { (changed) in
                }
            }.padding()
        }
        .onAppear() {
            symbol = position.symbol
            quote = position.quote
            isOwned = position.isOwned
            exitPrice = position.exitPrice
            periodDays = position.periodDays
            exitDate = position.endDate
        }
        .onDisappear() {
            db.save()
            db.refreshAllSymbols()
        }
    }
}

struct PositionEditor_Previews: PreviewProvider {
    static var testValue: Position {
        let position = Database.testPosition
        let scenarios = [Scenario(payout: 150, date: Date().add(days: 100), percentage: 0.4), Scenario(payout: 133, date: Date().add(days: 200), percentage: 0.6)]
        position.scenarios.replace(scenarios)
        return position
    }
    static var previews: some View {
        let testValue = testValue
        PositionEditor(position: testValue, scenarios: testValue.scenarios)
            .environmentObject(Database())
    }
}
