//
//  BackendAPIError.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

public enum BackendAPIError: Error {
    case requestBuildingError(RequestBuildingError)
    case requestExecutionError(RequestExecutionError)
    case unexpected(Error)
}
