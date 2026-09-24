//
//  LossyDecodable.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

// MARK: - Lossy Decodable
/// Decodes to `nil` instead of throwing, so one malformed element doesn't fail a whole array.
struct LossyDecodable<Value: Decodable>: Decodable {
    let value: Value?

    init(from decoder: Decoder) throws {
        value = try? Value(from: decoder)
    }
}
