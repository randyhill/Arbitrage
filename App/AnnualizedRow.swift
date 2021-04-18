//
//  ReturnField.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/17/21.
//

import SwiftUI

struct AnnualizedRow: View {
    var title: String
    var annualReturn: AnnualizedReturn
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            Text(annualReturn.priceString)
                .font(.headline)
                .fontWeight(.regular)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
           Text("Annualized:")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
            Text(annualReturn.annualizedString)
                .font(.headline)
                .fontWeight(.heavy)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .foregroundColor(annualReturn.textColor)
                .background(annualReturn.bgColor)
                .border(annualReturn.frameColor, width: 1)
        }
    }
}

struct ReturnField_Previews: PreviewProvider {
    static var previews: some View {
        let annualReturn = AnnualizedReturn(price: 9.987, exitPrice: 19, days: 364, isOwned: true)
        AnnualizedRow(title: "Bid:", annualReturn: annualReturn)
    }
}
