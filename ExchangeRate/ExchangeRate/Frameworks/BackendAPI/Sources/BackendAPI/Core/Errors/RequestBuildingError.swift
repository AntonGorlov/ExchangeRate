//
//  RequestBuildingError.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

public enum RequestBuildingError: Error {
    case serializationError(EncodingError)
    case urlRequestInitializationError(Error)
    case unexpected(Error)
}
