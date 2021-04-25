//
//  PositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/12/21.
//

import SwiftUI

struct PositionEditor: View {
    @Binding var position: Position
    @EnvironmentObject var db: Database
    
    // Private state
    @State private var bestCaseString = ""
    @State private var worstCaseString = ""
    @State private var symbol = ""
    @State private var latest = Date()
    @State private var worstCaseTitle = "Add 2nd Outcome"
    @State private var latestTitle = "Add 2nd Date"
    @State private var averageDays = 0

    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", text: $symbol)
            StockInfoPanel(position: position)
            TextFieldActive(title: "Outcome: $", placeholder: "0.0", text: $bestCaseString)
                .keyboardType(.decimalPad)
            HStack {
                Text("Completion Date:")
                Spacer()
                DatePicker("", selection: $position.soonest, displayedComponents: .date)
                    .frame(width: 124, alignment: .trailing)
            }
            if position.worstCase == nil {
                Button(worstCaseTitle) {
                    position.worstCase = position.bestCase
                    worstCaseTitle = ""
                }
            } else {
                TextFieldActive(title: "2nd Case: $", placeholder: "0.0", text: $worstCaseString)
                    .keyboardType(.decimalPad)
            }
             HStack {
                if position.latest == nil {
                    Button(latestTitle) {
                        position.latest = position.soonest
                        let next = position.soonest.add(days: 1)
                        latest = next
                        latestTitle = ""
                    }
                } else {
                    Text("Second Date: ")
                    DatePicker("", selection: $latest, displayedComponents: .date)
                        .frame(width: 124, alignment: .trailing)
                        .onChange(of: latest, perform: { newDate in
                            position.latest = latest
                            averageDays = position.periodDays
                        })
                }
             }
            HStack {
                Text("Average Days: \(averageDays)")
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
            bestCaseString = position.bestCaseString
            worstCaseString = position.worstCaseString
            averageDays = position.periodDays
            if let latest = position.latest {
                self.latest = latest
            }
            symbol = position.symbol
        }
        .onDisappear() {
            position.bestCaseString = bestCaseString
            position.worstCaseString = worstCaseString
            if latestTitle.count == 0 {
                position.latest = latest
            }
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
