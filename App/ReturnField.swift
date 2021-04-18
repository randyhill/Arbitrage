//
//  ReturnField.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct ReturnField: View {
    var title: String
    var price: Double
    var annualizedReturn: Double
    var returnColor: Color
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            Text("Annualized: \(String.toPercent(annualizedReturn))")
                .font(.headline)
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .background(returnColor)

        }
    }
}

struct ReturnField_Previews: PreviewProvider {
    static var previews: some View {
        ReturnField()
    }
}
