//
//  ArbitrageApp.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

@main
struct ArbitrageApp: App {
    @StateObject var database = Database.shared
    
    var body: some Scene {
        WindowGroup {
            DashboardView(positions: database.positions).environmentObject(database)
        }
    }
}
