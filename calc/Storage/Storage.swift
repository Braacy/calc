//
//  Storage.swift
//  calc
//
//  Created by Владислав Близнюк on 12.09.2025.
//

import Foundation

struct Calculation {
   let expressions: [CalculatorHistory]
   let result: Double
}

extension Calculation: Codable {
    
}

extension CalculatorHistory: Codable {
    enum CodingKeys: String, CodingKey {
        case number
        case operation
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .number(let value):
            try container.encode(value, forKey: CodingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    enum CalculatorHistoryError: Error {
       case itemNotFound
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let number = try? container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
            return
        }
        
        if let rawOperation = try? container.decodeIfPresent(String.self, forKey: .operation),
        let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
        throw CalculatorHistoryError.itemNotFound
    }
}

class CalculationHistoryStorage {
    static let calculatorHistoryKey = "calculationHistoryKey"
    
    func setHistory(calculation: [Calculation]) {
        if let encoded = try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoded, forKey: CalculationHistoryStorage.calculatorHistoryKey)
        }
    }
    
    func loadHistory() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculatorHistoryKey) {
            return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
        }
        return []
    }
}
