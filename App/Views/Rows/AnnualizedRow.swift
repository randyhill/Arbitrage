//
//  ReturnField.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct AnnualizedRow: View {
    @Binding var position: Position
    private let font = Font.callout
    
    var body: some View {
        HStack {
            let annualReturn = position.annualizedReturnFor(.purchase)
            Text(position.symbol)
                .font(font)
                .fontWeight(.semibold)
                .frame(width: 72, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            if position.quote?.bidPrice != nil, position.quote?.askPrice != nil, position.quote?.midPoint != nil {
                Spacer().frame(width: 8)
                AnnualizedPrice(annualReturn: position.annualizedReturnFor(.bid), alignment: .center)
                AnnualizedPrice(annualReturn: position.annualizedReturnFor(.mid), alignment: .center)
                AnnualizedPrice(annualReturn: position.annualizedReturnFor(.ask), alignment: .center)
            } else {
                Spacer().frame(width: 40)
                AnnualizedPrice(annualReturn: position.annualizedReturnFor(.purchase), alignment: .trailing, preText: "$")
                Spacer().frame(width: 40)
                Text(annualReturn.annualizedString)
                   .font(font)
                   .fontWeight(.heavy)
           }
//            let APR = position.annualizedReturnFor(.ask)
//            Text("\(APR.annualizedString)")
//                .font(.caption2)
//                .fontWeight(.semibold)
//                .frame(width: 40, alignment: .leading)

        }
    }
}

struct ReturnField_Previews: PreviewProvider {
    static var previews: some View {
        AnnualizedRow(position: .constant(Database.testPosition2))
    }
}
