//
//  PGYToken.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/5.
//

import Foundation

protocol SendCodable: Sendable, Codable { }

// MARK: - PGYResponse
struct PGYResponseData<T: SendCodable>: SendCodable {
    let code: Int
    let message: String
    let data: T?
}

// MARK: - PGYToken
struct PGYToken: SendCodable {
    let params: Params
    let key: String
    let endpoint: String
}

// MARK: - Params
struct Params: SendCodable {
    let signature, xCosSecurityToken, key: String

    enum CodingKeys: String, CodingKey {
        case signature
        case xCosSecurityToken = "x-cos-security-token"
        case key
    }
}



// MARK: - PGYBuildInfo
struct PGYBuildInfo: SendCodable {
    let buildQRCodeURL: String
    let buildShortcutUrl: String
    let buildName: String
}
