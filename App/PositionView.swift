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
        HStack {
            NavigationLink(
                destination: PositionEditor(position: $position),
                label: {
                    PositionReturns(position: $position)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(4.0)
             })
        }
    }
}

struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        PositionView(position: .constant(Database.testPositions.first!))
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
