//
//  CurrenciesResponseData.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

public struct CurrenciesResponseData: Decodable, Sendable {
    public let currencies: [String: String]
    
    ///Implements a custom init(from:) decoder
    ///Uses a single value container since the entire JSON is one dictionary
    ///Directly decodes it into a [String: String] dictionary
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.currencies = try container.decode([String: String].self)
    }
}

