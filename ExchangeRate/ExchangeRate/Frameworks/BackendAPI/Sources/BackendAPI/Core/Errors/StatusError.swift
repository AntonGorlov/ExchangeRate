//
//  StatusError.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Warning! Status code may be different. It's for example.
/// Consult with your backend team
public enum StatusError: Int, Error {
    case badRequest          = 400
    case unauthorized        = 401
    case forbidden           = 403
    case notFound            = 404
    case methodNotAllowed    = 405
    case notAcceptable       = 406
    case requestTimeout      = 408
    case internalServerError = 500
    case notDefined
    
    internal init(_ rawValue: Int) {
        self = Self(rawValue: rawValue) ?? .notDefined
    }
}
