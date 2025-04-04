//
//  ViewState.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation

/// State Machine pattern
enum ViewState: Equatable {
    case loading
    case error(ExchangeRateError)
    case empty
    case content
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.empty, .empty), (.content, .content):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
