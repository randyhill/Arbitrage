//
//  ContentView.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var db: Database
    @State private var isShowingDetailView = false
    @State var navigationTitle = "Positions"
    @State var newPosition = Position()

    var body: some View {
        NavigationView {
            List {
                ForEach(db.sorted.indices, id: \.self) { index in
                    // Need unique id for view so it doesn't open twice when dashboard refreshed.
                    let position = db.positions[index]
                    PositionView(position: position, tag: index)
                }
            }
            .onAppear() {
                db.refreshAllSymbols()
            }
            .toolbar {
                 ToolbarItem(placement: .principal) {
                    AppTitleBar(isShowingDetailView: $isShowingDetailView, title: $navigationTitle)
                        .environmentObject(db)
                   }
            }
        }
        .fullScreenCover(isPresented: $isShowingDetailView, content: {
            NewPositionEditor(isShowingDetailView: $isShowingDetailView, newPosition: $newPosition)
                .environmentObject(db)
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(Database())
    }
}

