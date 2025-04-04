//
//  AnyAPIContoller.swift
//  BackendAPI
//
//  Created by Anton Gorlov on 01.04.2025.
//

import Foundation

/// The AnyAPIController class is a generic API controller that provides shared functionality for making network requests and handling JSON encoding/decoding. It is designed to be extended or used as a base class for more specific API controllers.
public class AnyAPIContoller {
    
    ///  JSONEncoder configured with an .iso8601 date encoding strategy.
    internal lazy var encoder: JSONEncoder = {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        return encoder
    }()
    
    /// JSONDecoder configured with a custom .default date decoding strategy.
    internal lazy var decoder: JSONDecoder = {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .default
        
        return decoder
    }()
    
    internal var requestExecuter: IRequestExecuter = AlamofireRequestExecuter()
    
    public init() {}
    
}
