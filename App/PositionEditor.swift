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

    var body: some View {
        Form {
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", text: $position.symbol)
            HStack {
                Text("Current Price: \(position.priceString)")
            }
            TextFieldActive(title: "Best Case: $", placeholder: "0.0", text: $bestCaseString)
                .keyboardType(.decimalPad)
            HStack {
                Text("Soonest: ")
                DatePicker("", selection: $position.soonest, displayedComponents: .date)
                    .frame(width: 124, alignment: .trailing)
            }
            TextFieldActive(title: "Worst Case: $", placeholder: "0.0", text: $worstCaseString)
                .keyboardType(.decimalPad)
            HStack {
                Text("Latest: ")
                DatePicker("", selection: $position.latest, displayedComponents: .date)
                    .frame(width: 124, alignment: .trailing)
            }
            HStack {
                Text("Average Days: \(position.periodDays)")
            }
            HStack {
                Checkbox(isChecked: $position.isOwned, title: "Owned") { (changed) in
                    print("IsOwned: \(changed)")
                }
                Spacer()
                Checkbox(isChecked: $position.buyNotifications, title: "Notifications") { (changed) in
                    print("Notifications: \(changed)")
                }
            }.padding()
        }
        .onAppear() {
            bestCaseString = position.bestCaseString
            worstCaseString = position.worstCaseString
        }
        .onDisappear() {
            position.bestCaseString = bestCaseString
            position.worstCaseString = worstCaseString
        }
    }
}

struct PositionEditor_Previews: PreviewProvider {
    static var previews: some View {
        PositionEditor(position: .constant(Database.testPosition))
            .environmentObject(Database())
    }
}
