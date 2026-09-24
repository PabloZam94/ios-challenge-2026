//
//  String+Trimmed.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
