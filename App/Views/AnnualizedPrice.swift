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
    let font = Font.callout
    let weight = Font.Weight.heavy
    var body: some View {
        let width: CGFloat = preText != nil ? 90.0 : 72.0
        HStack {
            if let preText = preText {
                Text(preText)
                    .font(font)
                    .fontWeight(weight)
                    .foregroundColor(annualReturn.textColor)
                    .frame(alignment: .leading)
            }
            Text(annualReturn.priceString2)
                .font(font)
                .fontWeight(weight)
                .frame(alignment: alignment)
        }
        .foregroundColor(annualReturn.textColor)
        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        .background(annualReturn.bgColor)
        .border(annualReturn.frameColor, width: 1)
        .frame(width: width, alignment: .trailing)

    }
}

struct AnnualizedPrice_Previews: PreviewProvider {
    static var previews: some View {
        AnnualizedPrice(annualReturn: Database.testPosition.annualizedReturnFor(.purchasePrice), alignment: .center, preText: "$")
    }
}
