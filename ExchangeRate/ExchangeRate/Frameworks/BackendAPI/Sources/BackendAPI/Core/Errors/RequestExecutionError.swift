//
//  RequestExecutionError.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Errors that may occur when executing a request
public enum RequestExecutionError: Error, Sendable {
    /// When there's no internet connection
    case networkUnavailable
    /// When the request takes too long
    case timeout
    /// When connection drops mid-request
    case connectionInterrupted
    /// When server returns no data
    case dataIsEmpty
    /// When server returns an error status code
    case httpStatusError(StatusError)
    /// When JSON decoding fails
    case serializationError(Error)
    /// For any other unforeseen errors
    case unexpected(Error?)
}

extension RequestExecutionError: Equatable {
    public static func == (lhs: RequestExecutionError, rhs: RequestExecutionError) -> Bool {
        switch (lhs, rhs) {
        case (.networkUnavailable, .networkUnavailable):
            return true
        case let (.httpStatusError(lhs), .httpStatusError(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
    
}

