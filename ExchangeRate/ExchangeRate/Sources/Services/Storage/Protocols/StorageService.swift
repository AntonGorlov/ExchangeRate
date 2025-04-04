//
//  StorageService.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation

/// If there is a lot of data and it needs to be stored securely, then the best choice is Core Data or Realm
class StorageService: IStorageService {
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteCurrencies"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveFavoriteCurrencies(_ currencies: [CurrencyModel]) {
        do {
            let data = try JSONEncoder().encode(currencies)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            debugPrint("Failed to encode favorites: \(error)")
        }
    }
    
    func loadFavoriteCurrencies() -> [CurrencyModel] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return [] // Return empty array if no data exists
        }
        do {
            let currencies = try JSONDecoder().decode([CurrencyModel].self, from: data)
            return currencies
        } catch {
            debugPrint("Failed to decode favorites: \(error)")
            return []
        }
    }
    
    func clearFavoriteCurrencies() {
        userDefaults.removeObject(forKey: favoritesKey)
    }
    
}
