//
//  DateRow.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/18/21.
//

import SwiftUI

struct DateRow: View {
    var title: String
    var position: Position
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.headline)
                .fontWeight(.bold)
            Text(position.endDate.toFullUniqueDate())
                .font(.headline)
                .fontWeight(.regular)
            Text("Days:")
                .font(.headline)
                .fontWeight(.bold)
            Text("\(position.periodDays)")
                .font(.headline)
                .fontWeight(.regular)
        }
     }
}

struct DateRow_Previews: PreviewProvider {
    static var previews: some View {
        DateRow(title: "Date", position: Database.testPosition)
    }
}
