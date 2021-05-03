//
//  NewPositionEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/23/21.
//

import SwiftUI

struct NewPositionEditor: View {
    @EnvironmentObject var db: Database
    @Binding var isShowingDetailView: Bool
    @Binding var newPosition: Position
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Button("Cancel") {
                    isShowingDetailView = false
                }
                .padding()
                Spacer()
                Button("Save") {
                    // Not only do we save new position to database
                    // But make sure to replace it so next new
                    // isn't pointing at the now exiting position.
                    isShowingDetailView = false
                    db.addPosition(newPosition)
                    newPosition = Position()
                }
                .padding()
            }
            .frame(alignment: .trailing)
            PositionEditor(position: newPosition, activateTickerField: true)
                .environmentObject(db)
        }
    }
}

struct NewPositionEditor_Previews: PreviewProvider {
    static var previews: some View {
        NewPositionEditor(isShowingDetailView: .constant(true), newPosition: .constant(Database.testPosition))
            .environmentObject(Database())
    }
}
