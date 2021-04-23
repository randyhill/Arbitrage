//
//  ArbitrageApp.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

@main
struct ArbitrageApp: App {
    @StateObject private var database = Database()
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            DashboardView().environmentObject(database)
                .onChange(of: scenePhase, perform: { value in
                    if value == .active {
                        database.refreshAllSymbols()
                    }
                })
        }
    }
}
