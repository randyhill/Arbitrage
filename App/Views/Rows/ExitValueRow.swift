//
//  ExitValuesRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ExitValueRow: View {
    @Binding var exitPrice: Double
    @Binding var periodDays: Int
    @Binding var endDate: Date
    let font = Font.footnote

    var body: some View {
        HStack {
            Text("Exit:")
                .font(font)
                .fontWeight(.bold)
                .frame(width: 60, alignment: .leading)
            Text("\(exitPrice.currency)")
                .font(font)
                .frame(width: 44, alignment: .leading)
            Text("Days:")
                .font(font)
                .fontWeight(.bold)
                .frame(width: 50, alignment: .trailing)
            Text("\(periodDays)")
                .font(font)
                .frame(width: 30, alignment: .leading)
            Text("\(endDate.toUniqueTimeDayOrDate())")
                .font(.caption2)
                .frame(width: 110, alignment: .trailing)
        }
    }
}

struct ExitValuesRow_Previews: PreviewProvider {
    static var previews: some View {
        ExitValueRow(exitPrice: .constant(34.97), periodDays: .constant(30), endDate: .constant(Date().add(months:1)))
    }
}
