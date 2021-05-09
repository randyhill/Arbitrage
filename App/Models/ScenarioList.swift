//
//  ScenarioList.swift
//  Arbitrage
//
//  Created by Randy Hill on 4/30/21.
//

import SwiftUI

class ScenarioList: ObservableObject, Identifiable, Equatable {
    static func == (lhs: ScenarioList, rhs: ScenarioList) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    @Published var list = [Scenario]()
    
    var averageDays: Int {
        var aveDays = list.reduce(0) { days, scenario in
            return days + scenario.averageDays
        }
        // Round up so that tommorrow is one day away, even if it's only 12 hours away.
        if aveDays.truncatingRemainder(dividingBy: 1) >= 0.5 {
            aveDays += 1
        }
        return Int(aveDays)
    }
    
    var averagePayout: Double {
        let avePayout = list.reduce(0) { payouts, scenario in
            return payouts + scenario.averagePayout
        }
        return avePayout
    }
    
    var description: String {
        guard list.count > 0 else {
            return "Scenarios: Empty"
        }
        var ds: String = "Scenarios: "
        for scenario in list {
            ds += scenario.description + "\n"
        }
        return ds
    }

    
    init() {
        self.id = UUID().uuidString
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        list = try container.decode([Scenario].self, forKey: .list)
    }

    
    // Only allow one deletion at a time
    func deleteAt(_ indexes: IndexSet) {
        if let index = indexes.first {
            list.remove(at: index)
        }
        recalcPercentagesTo(total: 1.0, unchanged: list)
    }
    
    // Percentages for combined scenarios should always add up to 1 (100%)
    // If one of the scenarios has it's percentage changed, allocate the remaining amount proportionately among other scenarios
    func recalcOtherPercentages(_ changed: Scenario) {
        guard list.count > 0 else {
            changed.pctFraction = 1.0
            return
        }
        let unchanged = list.filter { scenario in
            return scenario != changed
        }

        let remainingPercent = (1.0 - changed.pctFraction)
        if list.count == 2 {
            // Only one other scenario so make it the inverse of our current scenario
            unchanged.first?.pctFraction = remainingPercent
        } else {
            recalcPercentagesTo(total: Double(remainingPercent), unchanged: unchanged)
        }
     }
    
    // Proportionately reduce/increase current percentages to total value given
    // Typically increasing remaining to to tototal 100% after deleting a scenario.
    func recalcPercentagesTo(total: Double = 1, unchanged: [Scenario]) {
        guard total <= 1, total >= 0 else {
            return Log.error("Can't recalc percentages to total: \(total)")
        }
        let currentTotal = unchanged.reduce(0) { total, next in
            return total + next.pctFraction
        }
        Log.assert(currentTotal > 0)
        if currentTotal > 0 {
            let adjustment = total/currentTotal
            for scenario in unchanged {
                let newPercentage = scenario.pctFraction * adjustment
                scenario.pctFraction = newPercentage
            }
        }
     }
    
    func get(_ index: Int) -> Scenario {
        return list[index]
    }
    
    func replace(_ newScenarios: [Scenario]) {
        list.removeAll()
        list.append(contentsOf: newScenarios)
    }
    
    func add(_ newScenario: Scenario) {
        guard list.count > 0 else {
            newScenario.pctFraction = 1
            list += [newScenario]
            return
        }
        recalcOtherPercentages(newScenario)
        list += [newScenario]
    }
}

extension ScenarioList: Codable {
    
    enum CodingKeys: CodingKey {
        case id
        case list
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(list, forKey: .list)
    }
}
