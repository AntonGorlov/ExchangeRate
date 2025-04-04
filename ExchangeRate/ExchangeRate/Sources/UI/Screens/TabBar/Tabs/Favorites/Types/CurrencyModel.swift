//
//  CurrencyModel.swift
//  ExchangeRate
//
//  Created by Anton Gorlov on 03.04.2025.
//

import Foundation

struct CurrencyModel: Codable, Hashable {
    let code: String
    let name: String
    let rate: String
}
