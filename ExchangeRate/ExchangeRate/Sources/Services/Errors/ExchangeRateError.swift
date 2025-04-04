//
//  ExchangeRateError.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation

enum ExchangeRateError: LocalizedError {
    case invalidFormat(String)
    case networkError(Error)
    case requestFailed(String)
    case serverError(String)
    case conversionFailed(String)
    case rateLimitExceeded
    case noInternetConnection
    case dataIsEmpty
    case unexpected(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        case .conversionFailed(let message):
            return "Conversion failed: \(message)"
        case .noInternetConnection:
            return "No internet connection. Check your connection."
        case .dataIsEmpty:
            return "Your request was not processed, Empty data was received."
        case .unexpected(let message):
            return "Something went wrong: \(message)"
        case .requestFailed(let message):
            return "Request failed: \(message)"
        case .invalidFormat(let message):
            return "Invalid format data: \(message)"
        case .rateLimitExceeded:
            return "Too many requests. Please try again later."
        }
    }
}
