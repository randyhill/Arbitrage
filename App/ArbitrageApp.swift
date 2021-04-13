//
//  ArbitrageApp.swift
//  Shared
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

@main
struct ArbitrageApp: App {
    var body: some Scene {
        let database = Database.shared
        WindowGroup {
            DashboardView()
        }
    }
}
