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
    
    var daysTillDate: String {
        switch periodDays {
        case 0, 1:
            return endDate.toFullUniqueDate()
        default:
            return "\(periodDays) days till \(endDate.toFullUniqueDate())"
        }
    }

    var body: some View {
        HStack {
            Text("Exit:")
                .font(font)
                .fontWeight(.bold)
                .frame(width: 60, alignment: .leading)
            Text("\(exitPrice.currency)")
                .font(font)
                .frame(width: 50, alignment: .leading)
            Text(daysTillDate)
                .font(font)
                .frame(width: 190, alignment: .trailing)
        }
    }
}

struct ExitValuesRow_Previews: PreviewProvider {
    static var previews: some View {
        let days = 3
        ExitValueRow(exitPrice: .constant(34.97), periodDays: .constant(days), endDate: .constant(Date().add(days:days)))
    }
}
