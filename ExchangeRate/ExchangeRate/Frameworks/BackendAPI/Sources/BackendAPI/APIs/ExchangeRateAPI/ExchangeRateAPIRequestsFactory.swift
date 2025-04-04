//
//  ExchangeRateAPIRequestsFactory.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation
import Alamofire

class ExchangeRateAPIRequestsFactory: IExchangeRateAPIRequestsFactory {
    var endpointsBuilder: IExchangeRateAPIEndpointsFactory
    
    private(set)var configuration: any IConfiguration
    
    init(_ configuration: IConfiguration) {
        self.configuration = configuration
        endpointsBuilder = ExchangeRateAPIEndpointsFactory(configuration: configuration)
    }
    
    func buildCurrenciesRequest() async throws -> URLRequest {
        do {
            let endpoint = endpointsBuilder.getCurrenciesURL()
            let headers  = HTTPHeaders(configuration.commonHeaders)
            
            return try URLRequest(url: endpoint, method: .get, headers: headers)
        } catch let error as EncodingError {
            throw RequestBuildingError.serializationError(error)
        } catch let initializationError {
            throw RequestBuildingError.urlRequestInitializationError(initializationError)
        }
    }
    
    func buildCurrencyListRequest(requestData: CurrencyListRequestData) async throws -> URLRequest {
        do {
            let endpoint = endpointsBuilder.getCurrencyListURL(baseCurrency: requestData.baseCurrency)
            let headers  = HTTPHeaders(configuration.commonHeaders)
            return try URLRequest(url: endpoint, method: .get, headers: headers )
        } catch let error as EncodingError {
            throw RequestBuildingError.serializationError(error)
        } catch let initializationError {
            throw RequestBuildingError.urlRequestInitializationError(initializationError)
        }
    }
    
    
}
