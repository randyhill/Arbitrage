//
//  PositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/12/21.
//

import SwiftUI

struct PositionEditor: View {
    @State var position: Position
    @ObservedObject var db: Database
    
    // Private state
    @State private var bestCaseString = ""

    var body: some View {
        Form {
            HStack {
                Checkbox(isChecked: $position.isOwned) { (changed) in
                    print("is changed: \(changed)")
                }
                Text("Owned")
            }
            TextFieldActive(title: "Ticker:", placeholder: "Ticker", text: $position.ticker)
            TextFieldActive(title: "Best Case: $", placeholder: "$0.0", text: $bestCaseString)
                .keyboardType(.decimalPad)
//            TextFieldActive(title: "Ticker", text: $position.ticker)
//            TextFieldActive(title: "Ticker", text: $position.ticker)
//            TextFieldActive(title: "Ticker", text: $position.ticker)
        }
        .onDisappear() {
            position.bestCaseString = bestCaseString
            db.updatePosition(position)
        }
        .onAppear() {
            bestCaseString = position.bestCaseString
        }
    }
}
