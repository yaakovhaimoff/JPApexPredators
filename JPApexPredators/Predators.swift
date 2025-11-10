//
//  Predators.swift
//  JPApexPredators
//
//  Created by Yaakov Haimoff on 9.11.2025.
//

import Foundation

class Predators {
    var allApexPredators: [ApexPredators] = []
    var apexPredators: [ApexPredators] = []
    
    init() {
        decodeApexPredatorsData()
    }
    
    func decodeApexPredatorsData() {
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                apexPredators = try decoder.decode([ApexPredators].self, from: data)
                allApexPredators = apexPredators
            }
            catch {
                print("Error decoding Json data: \(error)")
            }
        }
    }
    
    func search(for searchTerm: String) -> [ApexPredators] {
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            return apexPredators.filter {
                predator in
                predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func sort(by alphabetical: Bool) {
        apexPredators.sort { predator1, predator2 in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    
    func filter(by type: APType) {
        if type == .all {
            apexPredators = allApexPredators
        }
        else {
            apexPredators = allApexPredators.filter { predator in
                predator.type == type
            }
        }
    }
}
