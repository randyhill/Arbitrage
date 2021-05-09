//
//  PositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/12/21.
//

import SwiftUI

struct PositionEditor: View {
    @ObservedObject var position: Position
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
                            position.symbol = value
                        }
                    }
                })
            if let quote = quote {
                StockInfoPanel(quote: quote, isOwned: position.isOwned, exitPrice: $exitPrice, periodDays: $periodDays)
            }
            ExitValueRow(exitPrice: $exitPrice, periodDays: $periodDays, endDate: $exitDate)
            ScenarioTitleRow(position: position, exitPrice: $exitPrice)
                .environmentObject(db)

            List {
                ForEach(position.scenarios.list) { scenario in
                    ScenarioRow(scenario: scenario, position: position)
                        .environmentObject(db)
                        .onChange(of: position.scenarios.list, perform: { value in
                            exitPrice = position.exitPrice
                        })
                }
                .onDelete(perform: { indexSet in
                    position.scenarios.deleteAt(indexSet)
                    exitPrice = position.exitPrice
                })
            }
            HStack {
                Checkbox(isChecked: $isOwned, title: "Owned") { (changed) in
                    position.isOwned = changed
                 }
                Spacer()
                Checkbox(isChecked: $position.doNotify, title: "Notifications") { (changed) in
                }
            }
            .padding()
            .debug {
                Log.console("OPENED:\(position.description)")
            }
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
        }
    }
}

struct PositionEditor_Previews: PreviewProvider {
    static var testValue: Position {
        let position = Database.testPosition
        let scenarios = [Scenario(payout: 150, date: Date().add(days: 100), pctFraction: 0.4), Scenario(payout: 133, date: Date().add(days: 200), pctFraction: 0.6)]
        position.scenarios.replace(scenarios)
        return position
    }
    static var previews: some View {
        let testValue = testValue
        PositionEditor(position: testValue)
            .environmentObject(Database())
    }
}
