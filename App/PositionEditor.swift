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
    @State private var buttonTitle = "Add 2nd Date"

    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", text: $symbol)
            HStack {
                Text("Current Price: \(position.priceString)")
            }
            TextFieldActive(title: "Best Case: $", placeholder: "0.0", text: $bestCaseString)
                .keyboardType(.decimalPad)
            HStack {
                Text("Completion Date: ")
                DatePicker("", selection: $position.soonest, displayedComponents: .date)
                    .frame(width: 124, alignment: .trailing)
            }
            TextFieldActive(title: "Worst Case: $", placeholder: "0.0", text: $worstCaseString)
                .keyboardType(.decimalPad)
            HStack {
                if position.latest == nil {
                    Button(buttonTitle) {
                        position.latest = position.soonest
                        let next = position.soonest.add(days: 1)
                        latest = next
                        buttonTitle = ""
                    }
                } else {
                    Text("Second Date: ")
                    DatePicker("", selection: $latest, displayedComponents: .date)
                        .frame(width: 124, alignment: .trailing)
                }
             }
            HStack {
                Text("Average Days: \(position.periodDays)")
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
            symbol = position.symbol
        }
        .onDisappear() {
            position.bestCaseString = bestCaseString
            position.worstCaseString = worstCaseString
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
