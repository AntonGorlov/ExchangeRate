//
//  AlamofireRequestExecutor.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation
import Alamofire

/// This class is a robust and flexible solution for handling network requests in an iOS application using Alamofire.
/// Uses the Alamofire library to execute network requests. It handles both simple requests (where the response is not decoded) and requests where the response is expected to be a JSON object that can be decoded into a specified Decodable type. The class is designed to work in a concurrent environment, making it suitable for modern Swift concurrency.
class AlamofireRequestExecuter: IRequestExecuter {
    private let acceptableStatusCodes = 200..<300
    private let acceptableContentTypes = ["application/json", "application/x-www-form-urlencoded"]

    init() {
        AF.sessionConfiguration.timeoutIntervalForRequest = 15
        AF.sessionConfiguration.timeoutIntervalForResource = 10
    }
    
    func execute(_ request: URLRequest) async -> Result<Void, RequestExecutionError> {
        guard Reachability.isConnectedToNetwork() else {
            return .failure(.networkUnavailable)
        }
        
        let statusCodes = acceptableStatusCodes
        let contentTypes = acceptableContentTypes
        
        do {
            _ = try await AF.request(request)
                .validate(statusCode: statusCodes)
                .validate(contentType: contentTypes)
                .serializingData()
                .value
            return .success(())
        } catch let error as AFError {
            return .failure(mapError(error))
        } catch {
            return .failure(.unexpected(error))
        }
    }
    
    func execute<T: Decodable & Sendable>(_ request: URLRequest,
                                          decoder: JSONDecoder) async -> Result<T, RequestExecutionError> {
        guard Reachability.isConnectedToNetwork() else {
            return .failure(.networkUnavailable)
        }
        
        let statusCodes = acceptableStatusCodes
        let contentTypes = acceptableContentTypes
        
        do {
            let response = try await AF.request(request)
                .validate(statusCode: statusCodes)
                .validate(contentType: contentTypes)
                .serializingDecodable(T.self, decoder: decoder)
                .value
            return .success(response)
        } catch let error as AFError {
            return .failure(mapError(error))
        } catch {
            return .failure(.unexpected(error))
        }
    }
    
    private func mapError(_ error: AFError) -> RequestExecutionError {
        switch error {
        case .sessionTaskFailed(let urlError as URLError) where urlError.code == .timedOut:
            return .timeout
        case .sessionTaskFailed(let urlError as URLError) where urlError.code == .networkConnectionLost:
            return .connectionInterrupted
        default:
            if let statusCode = error.responseCode {
                return .httpStatusError(StatusError(statusCode))
            } else if error.isResponseSerializationError {
                return .serializationError(error)
            } else {
                return .unexpected(error)
            }
        }
    }
    
    private func getDataRequest(form urlRequest: URLRequest) -> DataRequest {
        return AF.request(urlRequest)
    }
}
