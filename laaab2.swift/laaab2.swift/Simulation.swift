
import Foundation

import Foundation

class Simulation: ObservableObject {
    @Published var results: [SimulationResult] = []
    
    func run(event: Event, iterations: Int) {
        results = []
        for i in 0..<iterations {
            let result = event.simulate()
            results.append(SimulationResult(id: i, result: result))
        }
    }
}

class Event {
    let name: String
    let outcomes: [String]
    let probabilities: [Double]
    
    init(name: String, outcomes: [String], probabilities: [Double]) {
        guard outcomes.count == probabilities.count,
              probabilities.reduce(0, +) == 1.0 else {
            fatalError("Invalid probabilities. They must sum to 1.")
        }
        self.name = name
        self.outcomes = outcomes
        self.probabilities = probabilities
    }
    
    func simulate() -> String {
        let random = Double.random(in: 0...1)
        var cumulativeProbability = 0.0
        for (index, probability) in probabilities.enumerated() {
            cumulativeProbability += probability
            if random <= cumulativeProbability {
                return outcomes[index]
            }
        }
        return outcomes.last!
    }
}
