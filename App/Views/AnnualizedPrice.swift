//
//  AnnualizedPrice.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/23/21.
//

import SwiftUI

struct AnnualizedPrice: View {
    var annualReturn: AnnualizedReturn
    var alignment: Alignment = .center
    var preText: String? = nil
    let font = Font.footnote
    let weight = Font.Weight.heavy
    var body: some View {
        let width: CGFloat = preText != nil ? 102 : 78
        HStack {
            if let preText = preText {
                Text(preText)
                    .font(font)
                    .fontWeight(weight)
                    .frame(alignment: .leading)
            }
            Text(annualReturn.priceString)
                .font(font)
                .fontWeight(weight)
                .frame(alignment: alignment)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .foregroundColor(annualReturn.textColor)
        .background(annualReturn.bgColor)
        .border(annualReturn.frameColor, width: 1)
        .frame(width: width)
    }
}

struct AnnualizedPrice_Previews: PreviewProvider {
    static var previews: some View {
        let ar = Database.testPosition.quote!.annualizedReturnFor(.ask, isOwned: false, exitPrice: 20.0, periodDays: 22)
        AnnualizedPrice(annualReturn: ar, alignment: .center, preText: "$")
    }
}
