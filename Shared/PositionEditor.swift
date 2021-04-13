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
    
    var body: some View {
        let standardPad: CGFloat = 4.0
        Form {
            HStack {
                Checkbox(isChecked: $position.isOwned) { (changed) in
                    print("is changed: \(changed)")
                }
                Text("Owned")
            }
            TextField("Ticker: ", text: $position.ticker)
        }
        .onDisappear() {
            db.updatePosition(position)
        }
    }
}
