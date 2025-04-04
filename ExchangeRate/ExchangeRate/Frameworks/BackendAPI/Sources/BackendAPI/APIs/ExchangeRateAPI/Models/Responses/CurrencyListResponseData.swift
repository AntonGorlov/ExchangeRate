//
//  CurrencyListResponseData.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

public struct CurrencyListResponseData: Decodable, Sendable {
    public let date: String
    public let list: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
    }
    
    // Nested container key that will be dynamic (eur, usd, etc.)
    struct DynamicKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? { nil }
        
        init?(intValue: Int) { nil }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        
        // Get the single dynamic key (base currency)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKey.self)
        let dynamicKeys = dynamicContainer.allKeys.filter { $0.stringValue != "date" }
        
        guard let baseCurrencyKey = dynamicKeys.first,
              let ratesContainer = try? dynamicContainer.nestedContainer(
                keyedBy: DynamicKey.self,
                forKey: baseCurrencyKey
              ) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [],
                                                    debugDescription: "Unable to find base currency key"))
        }
        
        // Decode all rates into the dictionary
        var rates: [String: Double] = [:]
        for key in ratesContainer.allKeys {
            rates[key.stringValue] = try ratesContainer.decode(Double.self, forKey: key)
        }
        self.list = rates
    }
}
