//
//  ExchangeRateAPIController.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation
public class ExchangeRateAPIController: AnyAPIContoller, IExchangeRateAPI {
    public var requestsBuilder: IExchangeRateAPIRequestsFactory
    
    public init(configuration: IConfiguration) {
        self.requestsBuilder = ExchangeRateAPIRequestsFactory(configuration)
    }
    
    public func currencies() async -> AvailableCurrenciesResult {
        do {
            let request = try await requestsBuilder.buildCurrenciesRequest()
            typealias Response = Result<CurrenciesResponseData, RequestExecutionError>
            
            let result: Response = await self.requestExecuter.execute(request, decoder: self.decoder)
            
            switch result {
            case .success(let response):
                return .success(response)
            case .failure(let executionError):
                return .failure(.requestExecutionError(executionError))
            }
        } catch let error as RequestBuildingError {
            return .failure(.requestBuildingError(error))
        } catch {
            return .failure(.requestBuildingError(.unexpected(error)))
        }
    }
    
    public func currencyList(_ requestData: CurrencyListRequestData) async -> CurrencyResult {
        do {
            let request = try await requestsBuilder.buildCurrencyListRequest(requestData: requestData)
            typealias Response = Result<CurrencyListResponseData, RequestExecutionError>
            
            let result: Response = await self.requestExecuter.execute(request, decoder: self.decoder)
            
            switch result {
            case .success(let response):
                return .success(response)
            case .failure(let executionError):
                return .failure(.requestExecutionError(executionError))
            }
        } catch let error as RequestBuildingError {
            return .failure(.requestBuildingError(error))
        } catch {
            return .failure(.requestBuildingError(.unexpected(error)))
        }
    }
    
    
}
