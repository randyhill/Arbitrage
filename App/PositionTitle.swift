//
//  PositionTitle.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct PositionTitle: View {
    @Binding var position: Position
    
    var body: some View {
        let title = "\(position.companyName) (\(position.symbol))\n\(position.priceString)"
        Text(title)
            .font(.title)
            .fontWeight(.bold)
    }
}

struct PositionTitle_Previews: PreviewProvider {
    static var previews: some View {
        PositionTitle(position: .constant(Database.testPosition))
    }
}
