//
//  Comments.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/7/21.
//

import SwiftUI

struct EquityModel: Codable, Identifiable {
    let id = UUID()
    let symbol: String
    let companyName: String
    let latestPrice: Double
}
