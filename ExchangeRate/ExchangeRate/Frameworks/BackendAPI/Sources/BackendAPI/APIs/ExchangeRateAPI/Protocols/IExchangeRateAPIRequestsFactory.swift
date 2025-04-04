//
//  IExchangeRateAPIRequestsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Defines a contract for creating URLRequest objects for exchange rate API requests. It abstracts the logic for constructing network requests, allowing different implementations (e.g., for different APIs or environments) to conform to the same interface.
public protocol IExchangeRateAPIRequestsFactory {
    /// Providing configuration
    var configuration: IConfiguration { get }
    
    /// Create a URLRequest for a get lists all the available currencies
    /// - Returns: URLRequest
    func buildCurrenciesRequest() async throws -> URLRequest
    
    /// Create a URLRequest for a currency list
    /// - Parameter requestData: Containing the details of the currency list
    /// - Returns: URLRequest
    func buildCurrencyListRequest(requestData: CurrencyListRequestData) async throws -> URLRequest
}
