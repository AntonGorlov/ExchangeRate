//
//  IExchangeViewModel.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation

/// Defines a contract for implement a viewModel
@MainActor
protocol IExchangeViewModel {
    var apiService: IExchangeRateService? { get }
    var storageService: IStorageService { get }
    var currenciesName: [String : String] { get set }
    var favoriteList: [CurrencyModel] { get set }
    var exchangeRates: [CurrencyModel] { get set }
    
    /// ViewState
    var stateOfCurrencies: ViewState { get set }
    
    init(apiService: IExchangeRateService?, storageService: IStorageService)
    
    /// Defining the base currency for the request. Default: "eur"
    func defineBaseCurrency() -> String
    
    /// Toggle a favorite currency
    /// - Parameter currencyCode: Current currency code
    func toggleFavorite(currencyCode: String)
    
    /// Allows chacking is favorite current currency
    /// - Parameter currencyCode: Current currency code
    /// - Returns: Bool
    func isFavorite(currencyCode: String) -> Bool
        
    /// Convert dictionary to Model for an UI layer
    /// - Parameter data: CurrencyData
    /// - Parameter currencies: available currencies [String : String]
    /// - Returns: [CurrencyModel]
    func mapTo(_ data: CurrencyData,
               currenciesName: [String : String]) -> [CurrencyModel]
    
    /// This is a straightforward way to control the number of decimal places.
    /// - Parameter doubleValue: Double
    /// - Returns: String
    func formatting(_ doubleValue: Double) -> String
    
    /// The method allows you to find objects that have already been added to your favorites and update them
    /// - Parameters:
    ///   - newModels: New list of data
    ///   - favoriteModels: Old list of data
    /// - Returns: Update list of data
    func updateFavoriteList(newModels: [CurrencyModel],
                            favoriteModels: [CurrencyModel]) -> [CurrencyModel]
    
    /// Get all available currencies
    func getAvailableCurrencies() async
    
    /// Get list of base currency exchange rate
    func getExchangeRates() async
}
