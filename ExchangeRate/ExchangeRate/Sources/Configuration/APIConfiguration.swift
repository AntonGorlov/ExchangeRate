//
//  APIConfiguration.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 02.04.2025.
//

import Foundation
import BackendAPI

// Configuration the backendAPI
struct APIConfiguration: IConfiguration {
    var baseURL: URL {
        URL(fileURLWithPath: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest")
    }
    
    var commonHeaders: [String : String] = [
        "Content-Type" : "application/json"
    ]
}
