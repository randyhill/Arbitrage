//
//  ContentView.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var db: Database
    @State var positions: [Position]
    private let textPadding: CGFloat = 0.5
    @State private var isShowingDetailView = false
    @State var newPosition = Position()
    @State var navigationTitle = "Stocks"

    var body: some View {
        NavigationView {
            List(positions) { position in
                VStack(alignment: .leading) {
                    NavigationLink(
                        destination: PositionEditor(position: position),
                        label: {
                            Text(position.currentState)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                    })
                    Text(position.bestCaseDescription)
                        .font(.subheadline)
                        .padding(textPadding)
                    Text("\(position.worstCaseDescription)")
                        .font(.subheadline)
                        .padding(textPadding)
                    Text("Average Days: \(position.averageDays)")
                        .font(.subheadline)
                        .padding(textPadding)
                    Text("Average Return: \(String.toPercent(position.totalReturn))")
                        .font(.subheadline)
                        .padding(textPadding)
                    Text("Annualized Return: \(String.toPercent(position.annualizedReturn))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                }
            }
            .onAppear() {
//                positions = Database.shared.positions
            }
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
                        positions = db.positions
                    }
                    .padding()
                }
                .frame(alignment: .trailing)
                PositionEditor(position: Position(ticker: ""))
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
        DashboardView(positions: Database.testPositions)
            .environmentObject(Database.shared)
    }
}
