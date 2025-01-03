//
//  API.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/6.
//

import Alamofire
import Logging
import Foundation

struct API {
    
    private static let logger = Logger(label: "API")
    
    static func POST<T: SendCodable>(_ convertible: any URLConvertible, parameters: Parameters? = nil) async throws -> T?{
        let value = try await AF.request(convertible, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .onHTTPResponse(perform: { response in
                logger.debug("\(response)")
            })
            .serializingDecodable(PGYResponseData<T>.self)
            .value
        if value.data == nil {
            logger.error("\(value.message)")
        }
        return value.data
    }
    
    
    static func GET<T: SendCodable>(_ convertible: any URLConvertible, parameters: Parameters? = nil) async throws -> T?{
        let value = try await AF.request(convertible, method: .get, parameters: parameters, encoding: URLEncoding.queryString)
            .onHTTPResponse(perform: { response in
                logger.debug("\(response)")
            })
            .serializingDecodable(PGYResponseData<T>.self)
            .value
        if value.data == nil {
            logger.error("\(value.message)")
        }
        return value.data
    }
    
    
    static func GET(_ convertible: any URLConvertible) async throws -> Data {
        let data = try await AF.request(convertible, method: .get)
            .onHTTPResponse(perform: { response in
                logger.debug("\(response)")
            })
            .serializingData()
            .value
        return data
    }
}

