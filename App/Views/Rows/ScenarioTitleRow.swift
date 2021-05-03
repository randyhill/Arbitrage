//
//  NewScenarioEditor.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/25/21.
//

import SwiftUI

struct ScenarioTitleRow: View {
    @EnvironmentObject var db: Database

    @ObservedObject var position: Position
    @Binding var exitPrice: Double
    @State private var newScenario: Scenario = Scenario()
    @State private var showScenarioEditor = false

    var body: some View {
        HStack {
            Text("Exit Scenarios")
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            Button("Add...") {
                newScenario = db.lastScenario.copy
                if position.scenarios.list.count == 0 {
                    newScenario.pctFraction = 1
                }
                position.scenarios.add(newScenario)
                showScenarioEditor = true
            }
        }
        .sheet(isPresented: $showScenarioEditor, content: {
            VStack (alignment: .leading) {
                HStack {
                    Button("Done") {
                        showScenarioEditor = false
                        exitPrice = position.exitPrice
                    }
                    .font(.title3.bold())
                    .frame(width: 100, alignment: .center)
                    .padding()
                    Spacer()
                }
            }
            ScenarioEditor(scenario: newScenario, position: position)
                .environmentObject(db)
        })
        .frame(height: 54, alignment: .bottom)
    }
}

struct NewScenarioEditor_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioTitleRow(position: Database.testPosition, exitPrice: .constant(22))
    }
}
