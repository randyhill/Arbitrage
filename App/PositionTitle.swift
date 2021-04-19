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
        HStack {
            Text(position.symbol)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .background(Color.black)
            Text(position.companyName)
                .font(.headline)
                .foregroundColor(Color.white)
                .background(Color.black)
        }
    }
}

struct PositionTitle_Previews: PreviewProvider {
    static var previews: some View {
        PositionTitle(position: .constant(Database.testPosition))
    }
}
