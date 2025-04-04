//
//  ExchangeRateTests.swift
//  ExchangeRateTests
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Testing
@testable import ExchangeRate

// MARK: - Mocks

class MockExchangeRateService: IExchangeRateService {
    var getCurrenciesCalled = false
    var getCurrencyListCalled = false
    var currenciesToReturn: CurrenciesData = CurrenciesData(currencies: ["test code" : "Name of currency"])
    var exchangeRatesToReturn: CurrencyData = CurrencyData(date: "sone data",
                                                           exchangeRates: ["test code" : 0.000])
    var errorToThrow: Error?
    
    func getCurrencies() async throws -> CurrenciesData {
        getCurrenciesCalled = true
        if let error = errorToThrow {
            throw error
        }
        return currenciesToReturn
    }
    
    func getCurrencyList(baseCurrency: String) async throws -> CurrencyData {
        getCurrencyListCalled = true
        if let error = errorToThrow {
            throw error
        }
        return exchangeRatesToReturn
    }
}

class MockStorageService: IStorageService {
    var savedFavorites: [CurrencyModel] = []
    var favoritesToLoad: [CurrencyModel] = []
    
    func saveFavoriteCurrencies(_ currencies: [CurrencyModel]) {
        savedFavorites = currencies
    }
    
    func loadFavoriteCurrencies() -> [CurrencyModel] {
        return favoritesToLoad
    }
    
    func clearFavoriteCurrencies() {
        favoritesToLoad.removeAll()
    }
}


struct ExchangeRateTests {
    
    @Test("ViewModel initializes with loaded favorites")
    func test_Initialization() async throws {
        // Given
        let mockApiService = MockExchangeRateService()
        let mockStorageService = MockStorageService()
        let favorites = [CurrencyModel(code: "usd",
                                       name: "US Dollar",
                                       rate: "1.000")]
        mockStorageService.favoritesToLoad = favorites
        
        // When
        let viewModel = await ExchangeViewModel(apiService: mockApiService,
                                                storageService: mockStorageService)
        
        // Then
        await #expect(viewModel.stateOfCurrencies == .loading)
        await #expect(viewModel.stateOfFavorite == .loading)
        await #expect(viewModel.favoriteList == favorites)
        await #expect(viewModel.stateOfFavorite == .content)
    }
    
    @MainActor
    @Test("Adding a currency to favorites works correctly")
    func test_Add_To_Favorites() async throws {
        // Given
        let mockApiService = MockExchangeRateService()
        let mockStorageService = MockStorageService()
        let viewModel = ExchangeViewModel(apiService: mockApiService,
                                                storageService: mockStorageService)
        let currency = CurrencyModel(code: "usd", name: "US Dollar", rate: "1.000")
        viewModel.exchangeRates = [currency]
        
        // When
        viewModel.toggleFavorite(currencyCode: "usd")
        
        // Then
        #expect(viewModel.favoriteList.count == 1)
        #expect(viewModel.favoriteList.first?.code == "usd")
        #expect(mockStorageService.savedFavorites.contains { $0.code == "usd" })
    }
    
    @MainActor
    @Test("Removing a currency from favorites works correctly")
    func test_Remove_From_Favorites() async throws {
        // Given
        let mockApiService = MockExchangeRateService()
        let mockStorageService = MockStorageService()
        let currency = CurrencyModel(code: "usd", name: "US Dollar", rate: "1.000")
        mockStorageService.favoritesToLoad = [currency]
        let viewModel = ExchangeViewModel(apiService: mockApiService,
                                          storageService: mockStorageService)
        
        // When
        viewModel.toggleFavorite(currencyCode: "usd")
        
        // Then
        #expect(viewModel.favoriteList.isEmpty)
        #expect(mockStorageService.savedFavorites.isEmpty)
    }
    
}
