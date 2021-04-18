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
    @State var navigationTitle = "Stocks"

    var body: some View {
        NavigationView {
            List {
                ForEach(db.positions.indices, id: \.self) { index in
                    PositionView(position: $db.positions[index])
                        .debug {
                            Log.console("Dashboard equity: \(db.positionAt(index).equity)")
                        }
                }

            }
//            .onAppear() {
//                positions = db.positions
//            }
            .toolbar {
                 ToolbarItem(placement: .principal) {
                    AppTitleBar(isShowingDetailView: $isShowingDetailView, newPosition: $newPosition, title: $navigationTitle)
                        .environmentObject(db)
                   }
            }
 
        }
        .fullScreenCover(isPresented: $isShowingDetailView, content: {
            VStack {
                HStack {
                    Button("Cancel") {
                        isShowingDetailView = false
                    }
                    .padding()
                    Spacer()
                    Button("Save") {
                        isShowingDetailView = false
                        db.addPosition(newPosition)
//                        positions = db.positions
                    }
                    .padding()
                }
                .frame(alignment: .trailing)
                PositionEditor(position: $newPosition)
                    .environmentObject(db)
            }
        })
        .background(Color.blue)
    }
}

struct AppTitleBar: View {
    @EnvironmentObject var db: Database
    @Binding var isShowingDetailView: Bool
    @Binding var newPosition: Position
    @Binding var title: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text($title.wrappedValue)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 80.0)
                Button(action: {
                    isShowingDetailView = true
                    newPosition = db.newPosition
                }, label: {
                    Image(systemName: "pencil.circle.fill")
                            .font(.largeTitle)
                })
                .frame(alignment: .trailing)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(Database())
    }
}

