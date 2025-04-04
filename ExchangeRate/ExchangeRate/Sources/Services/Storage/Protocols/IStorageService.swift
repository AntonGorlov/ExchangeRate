//
//  IStorageService.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation

protocol IStorageService {
    func saveFavoriteCurrencies(_ currencies: [CurrencyModel])
    func loadFavoriteCurrencies() -> [CurrencyModel]
    func clearFavoriteCurrencies()
}
