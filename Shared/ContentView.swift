//
//  ContentView.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct ContentView: View {
    //1.
    @ObservedObject var db = Database.shared
    
    var body: some View {
        NavigationView {
            //3.
            List(db.positions) { position in
                VStack(alignment: .leading) {
                    Text(position.currentState)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Text(position.bestCaseString)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(position.worstCaseString)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
            //2.
            .onAppear() {
//               let _ =  Database.shared
//                positions = Database.shared.positions
//                apiCall().getEquity(ticker: "TSLA") { stock in
//                    self.stocks += [stock]
//                }
            }.navigationTitle("Stocks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
