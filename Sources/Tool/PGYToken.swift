//
//  PGYToken.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/5.
//

import Foundation

import Foundation

// MARK: - PGYTOken
struct PGYResponseData: Codable {
    let code: Int
    let message: String
    let data: PGYToken
}

// MARK: - DataClass
struct PGYToken: Codable {
    let params: Params
    let key: String
    let endpoint: String
}

// MARK: - Params
struct Params: Codable {
    let signature, xCosSecurityToken, key: String

    enum CodingKeys: String, CodingKey {
        case signature
        case xCosSecurityToken = "x-cos-security-token"
        case key
    }
}
