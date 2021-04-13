//
//  ContentView.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var db = Database.shared
    
    var body: some View {
        NavigationView {
            List(db.positions) { position in
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: PositionEditor(position: position, db: db),
                        label: {
                            Text(position.currentState)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                    })
                    Text(position.bestCaseDescription)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(position.worstCaseDescription)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
            }
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
        DashboardView()
    }
}
