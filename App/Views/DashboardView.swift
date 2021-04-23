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
    @State var newPosition = Position()
    @State var navigationTitle = "Positions"

    var body: some View {
        NavigationView {
            List {
                ForEach(db.sorted.indices, id: \.self) { index in
                    PositionView(position: $db.positions[index])
                }
            }
            .toolbar {
                 ToolbarItem(placement: .principal) {
                    AppTitleBar(isShowingDetailView: $isShowingDetailView, newPosition: $newPosition, title: $navigationTitle)
                        .environmentObject(db)
                   }
            }
 
        }
        .fullScreenCover(isPresented: $isShowingDetailView, content: {
            VStack (alignment: .leading) {
                HStack {
                    Button("Cancel") {
                        isShowingDetailView = false
                    }
                    .padding()
                    Spacer()
                    Button("Save") {
                        isShowingDetailView = false
                        db.addPosition(newPosition)
                    }
                    .padding()
                }
                .frame(alignment: .trailing)
                PositionEditor(position: $newPosition)
                    .environmentObject(db)
            }
        })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(Database())
    }
}

