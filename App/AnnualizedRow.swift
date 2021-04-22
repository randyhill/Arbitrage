//
//  ReturnField.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct AnnualizedRow: View {
    @Binding var position: Position
    var priceType: Position.Spread
    private let font = Font.callout
    
    var body: some View {
        HStack {
            let annualReturn = position.annualizedReturnFor(priceType)
            let priceTitle = priceType == .ask ? "Ask:" : "Bid:"
            Text(position.symbol)
                .font(font)
                .fontWeight(.semibold)
                .frame(width: 72, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            Text(priceTitle)
                .font(Font.caption2)
                .fontWeight(.semibold)
                .frame(width: 36, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            Text(annualReturn.priceString)
                .font(font)
                .fontWeight(.regular)
                .frame(width: 72, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
            Spacer().frame(width: 52)
            Text(annualReturn.annualizedString)
                .font(font)
                .fontWeight(.heavy)
                .frame(width: 72, alignment: .trailing)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .foregroundColor(annualReturn.textColor)
                .background(annualReturn.bgColor)
                .border(annualReturn.frameColor, width: 1)
        }
    }
}

struct ReturnField_Previews: PreviewProvider {
    static var previews: some View {
        AnnualizedRow(position: .constant(Database.testPosition), priceType: .ask)
    }
}
