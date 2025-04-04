//
//  JSONDecoder+DateDecodingStrategy.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// Purpose: The extension adds a custom .default date decoding strategy to JSONDecoder. This strategy is designed to handle date strings in a flexible way, ensuring compatibility with various date formats commonly used in APIs.
extension JSONDecoder.DateDecodingStrategy {
    
    /// This ensures that dates in the API response are decoded correctly, even if they are in a non-standard format.
    static var `default`: Self {
        
        .custom({ (decoder) -> Date in
            
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            let isoFormatter = ISO8601DateFormatter()
            
            let options: [ISO8601DateFormatter.Options] = [
                
                .withFullDate,
                .withTime,
                .withDashSeparatorInDate,
                .withColonSeparatorInTime
            ]
            
            isoFormatter.timeZone = .autoupdatingCurrent
            isoFormatter.formatOptions = .init(options)
            
            if let date = isoFormatter.date(from: dateString) {
                
                return date
            }
            
            throw DecodingError.dataCorrupted(
                
                DecodingError.Context(
                    
                    codingPath: decoder.codingPath,
                    debugDescription: "Could not decode date with format \(dateString)"
                )
            )
            
        })
    }
    
}
