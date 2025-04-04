//
//  Configuration.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Defines a contract for providing configuration details required by an application, particularly for making network requests. It abstracts the configuration properties, making it easier to switch between different configurations (e.g., development, staging, production) or mock configurations for testing.
public protocol IConfiguration {
    var baseURL: URL { get }
    var commonHeaders: [String : String] { get }
}

/// A type that holds the base URL and other configuration details for the API.
public struct Configuration: IConfiguration {
    public var baseURL: URL
    
    public var commonHeaders: [String : String] = [
        "Content-Type" : "application/json"
    ]
}
