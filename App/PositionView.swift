//
//  PositionView.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/14/21.
//

import SwiftUI

struct PositionView: View {
    @Binding var position: Position
    private let textPadding: CGFloat = 0.5

    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(
                destination: PositionEditor(position: position),
                label: {
                    PositionTitle(position: $position)
                        .padding()
            })
            PositionReturns(position: $position)
        }
     }
}

struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        PositionView(position: .constant(Database.testPositions.first!))
    }
}
