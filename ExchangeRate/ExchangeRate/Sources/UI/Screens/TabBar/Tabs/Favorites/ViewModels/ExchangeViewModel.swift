//
//  ExchangeViewModel.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation

@MainActor
class ExchangeViewModel: IExchangeViewModel, ObservableObject {
    @Published var stateOfCurrencies: ViewState = .empty
    @Published var stateOfFavorite: ViewState = .empty
    @Published var currenciesName = [String : String]()
    @Published var favoriteList: [CurrencyModel] {
        didSet {
            storageService.saveFavoriteCurrencies(favoriteList)
            self.stateOfFavorite = self.favoriteList.isEmpty ? .empty : .content
        }
    }
    var exchangeRates = [CurrencyModel]()
    
    var apiService: IExchangeRateService?
    var storageService: IStorageService
    private var timer: Timer?
    
    required init(apiService: IExchangeRateService?, storageService: IStorageService) {
        self.apiService = apiService
        self.storageService = storageService
        self.favoriteList = storageService.loadFavoriteCurrencies()
        
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        Task {
            await getAvailableCurrencies()
            await getExchangeRates()
        }
        automaticAPIRefresh()
    }
    
    // MARK: - Favorites flow
    
    func toggleFavorite(currencyCode: String) {
        if let index = favoriteList.firstIndex(where: { $0.code == currencyCode }) {
            favoriteList.remove(at: index)
        } else {
            if let newFavorite = exchangeRates.first(where: { $0.code == currencyCode }) {
                favoriteList.append(newFavorite)
            }
        }
    }
    
    func isFavorite(currencyCode: String) -> Bool {
        favoriteList.contains { $0.code == currencyCode }
    }
    
    // MARK: - API calls
    
    func getAvailableCurrencies() async {
        stateOfCurrencies = .loading
        do {
            let result = try await apiService?.getCurrencies()
            guard let result = result else {
                stateOfCurrencies = .empty
                return
            }
            guard !result.currencies.isEmpty else {
                stateOfCurrencies = .empty
                return
            }
            currenciesName = result.currencies
            stateOfCurrencies = .content
        } catch let error as ExchangeRateError {
            stateOfCurrencies = .error(error)
            stopTimer()
        } catch {
            stateOfCurrencies = .error(.unexpected(error.localizedDescription))
            stopTimer()
        }
    }
    
    func getExchangeRates() async {
        stateOfFavorite = .loading
        let baseCurrency = defineBaseCurrency()
       
        do {
            let result = try await getCurrencyList(baseCurrency: baseCurrency)
            guard let result = result else {
                stateOfFavorite = .empty
                return
            }
            guard !result.exchangeRates.isEmpty else {
                stateOfFavorite = .empty
                return
            }
            let newModels = mapTo(result, currenciesName: currenciesName)
            exchangeRates = newModels
            favoriteList = updateFavoriteList(newModels: newModels,
                                              favoriteModels: favoriteList)
            stateOfFavorite = .content
        } catch let error as ExchangeRateError {
            stateOfFavorite = .error(error)
            stopTimer()
        } catch {
            stateOfFavorite = .error(.unexpected(error.localizedDescription))
            stopTimer()
        }
    }
    
    func updateFavoriteList(newModels: [CurrencyModel],
                            favoriteModels: [CurrencyModel]) -> [CurrencyModel] {
        var updatedFavorites = favoriteModels
        
        for model in newModels {
            if let index = updatedFavorites.firstIndex(where: { $0.name == model.name }) {
                updatedFavorites[index] = model
            }
        }
        return updatedFavorites
    }
    
    // MARK: - Base currency
    
    func defineBaseCurrency() -> String {
        let baseCurrency = "eur"
        
        if let object = favoriteList.first {
            return object.code
        }
        return baseCurrency
    }
    
    // MARK: - Mapper
    
    func mapTo(_ data: CurrencyData,
               currenciesName: [String : String]) -> [CurrencyModel] {
        data.exchangeRates.compactMap { (code, rate) in
            guard let name = currenciesName[code] else { return nil }
            return CurrencyModel(code: code, name: name, rate: formatting(rate))
        }
    }
    
    // MARK: - Formatter
    
    func formatting(_ doubleValue: Double) -> String {
        let truncated = Double(Int(doubleValue * 1000)) / 1000
        return String(format: "%.3f", truncated)
    }
    
    // MARK: - APIs
    
    private func getCurrencyList(baseCurrency: String) async throws -> CurrencyData? {
        return try await apiService?.getCurrencyList(baseCurrency: baseCurrency)
    }
    
    // MARK: Timer
    
    private func automaticAPIRefresh() {
        timer?.invalidate()
        timer = nil
     
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            Task {
                
                await self.getExchangeRates()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
