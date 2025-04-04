//
//  CurrencyListRequestData.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// The currency list with as base currency request data
public struct CurrencyListRequestData: Encodable {
    public let baseCurrency: String
    
    public init(baseCurrency: String) {
        self.baseCurrency = baseCurrency
    }
}
