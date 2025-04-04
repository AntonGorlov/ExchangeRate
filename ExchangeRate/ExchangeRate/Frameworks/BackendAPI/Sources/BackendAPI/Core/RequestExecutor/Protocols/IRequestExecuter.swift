//
//  IRequestExecuter.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Defines a contract for executing network requests.
protocol IRequestExecuter {
    
    /// Simple request with no response data.
    /// Used for requests where you don't need to parse response data (like POST/PUT/DELETE operations).
    /// - Parameter request: URLRequest
    /// - Returns: Swift.Result<Void, RequestExecutionError>
    func execute(_ request: URLRequest) async -> Result<Void, RequestExecutionError>
    
    /// Request with decoded response. Automatically decodes the response into type T.
    /// Used for requests where you expect JSON data back (like GET operations).
    /// - Parameters:
    ///   - request: URLRequest
    ///   - decoder: JSONDecoder
    /// - Returns: Swift.Result<T, RequestExecutionError>
    func execute<T: Decodable & Sendable>(_ request: URLRequest, decoder: JSONDecoder) async -> Result<T, RequestExecutionError>
}
