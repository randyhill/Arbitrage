//
//  ContentView.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct ContentView: View {
    //1.
    @State var stocks = [EquityModel]()
    
    var body: some View {
        NavigationView {
            //3.
            List(stocks) { comment in
                VStack(alignment: .leading) {
                    Text(comment.companyName)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(comment.symbol)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(comment.latestPrice)")
                        .font(.body)
                }
                
            }
            //2.
            .onAppear() {
                apiCall().getStockPrice(ticker: "TSLA") { stock in
                    self.stocks += [stock]
                }
            }.navigationTitle("Stocks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
