//
//  IExchangeRateAPIEndpointsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// A protocol that defines the interface for generating exchange rate API endpoints.
public protocol IExchangeRateAPIEndpointsFactory {
    
    /// Providing configuration
    var configuration: IConfiguration { get }
    
    init(configuration: IConfiguration)
    
    /// Constructs a URL for the available currencies request
    /// - Returns: A URL object representing the API endpoint
    func getCurrenciesURL() -> URL
    
    /// Constructs a URL for the base currency list
    /// - Parameter baseCurrency: bace currency
    /// - Returns: A URL object representing the API endpoint
    func getCurrencyListURL(baseCurrency: String) -> URL
}


