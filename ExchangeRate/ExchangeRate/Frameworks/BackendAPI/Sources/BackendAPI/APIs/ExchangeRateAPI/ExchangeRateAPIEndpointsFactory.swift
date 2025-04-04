//
//  ExchangeRateAPIEndpointsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

class ExchangeRateAPIEndpointsFactory: IExchangeRateAPIEndpointsFactory {
    private(set) var configuration: IConfiguration
    
    required init(configuration: IConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Endpoints
    
    // Example: https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json
    func getCurrenciesURL() -> URL {
        return configuration.baseURL
            .appending(path: "v1")
            .appending(path: "currencies.json")
    }
    
    // Example: https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json
    func getCurrencyListURL(baseCurrency: String) -> URL {
        return configuration.baseURL
            .appending(path: "v1")
            .appending(path: "currencies")
            .appending(path: "\(baseCurrency).json")
    }
    
    
}
