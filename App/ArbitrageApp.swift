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
    
    var body: some Scene {
        WindowGroup {
            DashboardView().environmentObject(database)
        }
    }
}
