//
//  PositionView.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/14/21.
//

import SwiftUI

struct PositionView: View {
    @ObservedObject var position: Position
    var tag: Int

    var body: some View {
         NavigationLink(
            destination:
                PositionEditor(position: position),
            label: {
                PositionRow(position: position)
            })
        .listRowBackground(Color.gray)
        .background(Color.black)
        .foregroundColor(Color.white)
        .cornerRadius(4.0)
    }
}

struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        let position = Database.testPositions.first!
        PositionView(position: position, tag: 1)
    }
}

struct CustomAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        return context[.trailing]
    }
}

extension HorizontalAlignment {
    static let custom: HorizontalAlignment = HorizontalAlignment(CustomAlignment.self)
}
