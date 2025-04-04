//
//  IExchangeRateService.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation
/// Defines a contract for executing exchange rate service
protocol IExchangeRateService {
    
    /// The method allows you to get a list of available currencies
    /// - Returns: CurrenciesData
    func getCurrencies() async throws -> CurrenciesData
    
    
    /// This method allows you to get a list of currencies with an exchange rate.
    /// - Parameter baseCurrency: The base currency against which the exchange rate is compared is set in baseCurrency: String (the request)
    /// - Returns: CurrencyData
    func getCurrencyList(baseCurrency: String) async throws -> CurrencyData
}


