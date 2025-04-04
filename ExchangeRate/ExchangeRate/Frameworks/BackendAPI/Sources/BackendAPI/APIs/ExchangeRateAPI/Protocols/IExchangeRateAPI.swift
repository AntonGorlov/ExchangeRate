//
//  IExchangeRateAPI.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Defines a contract for performing the exchange rate operations. It abstracts the logic for currency exchange rate and available currencies. Allowing different implementations (e.g., network-based, mock-based) to conform to the same interface.
public protocol IExchangeRateAPI {
    typealias AvailableCurrenciesResult = Result<CurrenciesResponseData, BackendAPIError>
    typealias CurrencyResult = Result<CurrencyListResponseData, BackendAPIError>
    
    /// The method allows you to get lists all the available currencies.
    /// - Returns: GetCurrenciesResult
    func currencies() async -> AvailableCurrenciesResult
   
    /// Get a list of currencies with a base currency that depends on the currency specified in requestData(CurrencyListRequestData)
    /// - Parameter requestData: CurrencyListRequestData
    /// - Returns: CurrencyResult
    func currencyList(_ requestData: CurrencyListRequestData) async -> CurrencyResult
}
