//
//  ScenarioList.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/30/21.
//

import SwiftUI

class ScenarioList: Identifiable, Codable {
    let id: String
    private var scenarios = [Scenario]()
    var list: [Scenario] {
        get {
            return scenarios
        }
        set {
            scenarios = newValue
        }
    }
    
    var averageDays: Int {
        var aveDays = scenarios.reduce(0) { days, scenario in
            return days + scenario.averageDays
        }
        if aveDays.truncatingRemainder(dividingBy: 1) >= 0.5 {
            aveDays += 1
        }
        return Int(aveDays)
    }
    
    var averagePayout: Double {
        let avePayout = scenarios.reduce(0) { payouts, scenario in
            return payouts + scenario.averagePayout
        }
        return avePayout
    }
    
    init() {
        self.id = UUID().uuidString
    }
    
    // Only allow one deletion at a time
    func deleteAt(_ indexes: IndexSet) {
        if let index = indexes.first {
            scenarios.remove(at: index)
        }
        recalcPercentages()
    }
    
    // Percentages should always add up to 1
    func recalcPercentages() {
        let currentTotal = scenarios.reduce(0) { total, next in
            return total + next.percentage
        }
        let multiplier = 1/currentTotal
        for scenario in scenarios {
            scenario.percentage *= multiplier
        }
    }
    
    func get(_ index: Int) -> Scenario {
        return scenarios[index]
    }
    
    func replace(_ newScenarios: [Scenario]) {
        scenarios.removeAll()
        scenarios.append(contentsOf: newScenarios)
    }
    
    func add(_ newScenario: Scenario) {
        guard scenarios.count > 0 else {
            newScenario.percentage = 1.0
            scenarios += [newScenario]
            return
        }
        let remainingAvailable = 1 - newScenario.percentage
        for scenario in scenarios {
            scenario.percentage *= remainingAvailable
        }
        scenarios += [newScenario]
    }
}
