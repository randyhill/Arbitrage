//
//  PositionView.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/14/21.
//

import SwiftUI

struct PositionView: View {
    @Binding var position: Position
    @State var scenarios: ScenarioList

    var body: some View {
         NavigationLink(
            destination:
                PositionEditor(position: position, scenarios: $scenarios),
            label: {
                AnnualizedRow(position: $position, priceType: .ask)
        })
        .listRowBackground(Color.gray)
        .background(Color.black)
        .foregroundColor(Color.white)
        .cornerRadius(4.0)
    }
}

struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        PositionView(position: .constant(Database.testPositions.first!), scenarios: Database.testPosition.scenarios)
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
