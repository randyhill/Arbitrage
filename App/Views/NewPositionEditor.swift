//
//  NewPositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/23/21.
//

import SwiftUI

struct NewPositionEditor: View {
    @EnvironmentObject var db: Database
    @Binding var newPosition: Position
    @Binding var isShowingDetailView: Bool
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Button("Cancel") {
                    isShowingDetailView = false
                }
                .padding()
                Spacer()
                Button("Save") {
                    isShowingDetailView = false
                    db.addPosition(newPosition)
                }
                .padding()
            }
            .frame(alignment: .trailing)
            PositionEditor(position: $newPosition, activateTickerField: true)
                .environmentObject(db)
        }
    }
}

struct NewPositionEditor_Previews: PreviewProvider {
    static var previews: some View {
        NewPositionEditor(newPosition: .constant(Database.testPosition), isShowingDetailView: .constant(true))
            .environmentObject(Database())
    }
}
