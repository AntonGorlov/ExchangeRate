//
//  ExchangeRateService.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation
import BackendAPI

class ExchangeRateService: IExchangeRateService {
    private let apiController: IExchangeRateAPI
    
    init(apiController: IExchangeRateAPI) {
        self.apiController = apiController
    }
    
    func getCurrencies() async throws -> CurrenciesData {
        
        let result = await apiController.currencies()
        
        switch result {
        case .success(let response):
            guard !response.currencies.isEmpty else {
                throw ExchangeRateError.dataIsEmpty
            }
            return mapTo(response)
        case .failure(let error):
            throw try errorsAPIHandler(error)
        }
    }
    
    func getCurrencyList(baseCurrency: String) async throws -> CurrencyData {
        let requestData = CurrencyListRequestData(baseCurrency: baseCurrency)
        
        let result = await apiController.currencyList(requestData)
        
        switch result {
        case .success(let response):
            guard !response.list.isEmpty else {
                throw ExchangeRateError.dataIsEmpty
            }
            return mapTo(response)
        case .failure(let error):
            throw try errorsAPIHandler(error)
        }
    }
    
    // MARK: Errors handler
    
    private func errorsAPIHandler(_ error: BackendAPIError) throws -> ExchangeRateError {
        switch error {
        case .requestBuildingError(let requestBuildingError):
            throw ExchangeRateError.requestFailed("Failed to build request: \(requestBuildingError)")
        case .requestExecutionError(let executionError):
            switch executionError {
            case .networkUnavailable, .connectionInterrupted:
                throw ExchangeRateError.noInternetConnection
            case .timeout:
                throw ExchangeRateError.networkError(executionError)
            case .dataIsEmpty:
                throw ExchangeRateError.dataIsEmpty
            case .httpStatusError(let statusError):
                switch statusError {
                case .badRequest:
                    throw ExchangeRateError.invalidFormat("Invalid request format")
                case .unauthorized:
                    throw ExchangeRateError.serverError("Authentication failed")
                case .forbidden:
                    throw ExchangeRateError.rateLimitExceeded
                case .notFound:
                    throw ExchangeRateError.serverError("Service not found")
                case .methodNotAllowed:
                    throw ExchangeRateError.serverError("Invalid method")
                case .internalServerError:
                    throw ExchangeRateError.serverError("Internal server error")
                default:
                    throw ExchangeRateError.serverError("Unknown server error")
                }
            case .serializationError(let error):
                throw ExchangeRateError.conversionFailed("Failed to parse response: \(error)")
            case .unexpected(let error):
                throw ExchangeRateError.unexpected("Unexpected error: \(error?.localizedDescription ?? "Unexpected")")
            }
        case .unexpected(let error):
            throw ExchangeRateError.unexpected("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func mapTo(_ response: CurrenciesResponseData) -> CurrenciesData {
        return CurrenciesData(currencies: response.currencies)
    }
    
    private func mapTo(_ response: CurrencyListResponseData) -> CurrencyData {
        return CurrencyData(date: response.date, exchangeRates: response.list)
    }
}
