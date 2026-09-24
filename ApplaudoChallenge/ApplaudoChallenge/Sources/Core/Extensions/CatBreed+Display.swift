//
//  CatBreed+Display.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import NetworkLayer

extension CatBreed {
    var displayName: String {
        Self.displayText(name, fallback: "Unknown Breed")
    }

    var displayDescription: String {
        Self.displayText(description, fallback: "No description available.")
    }

    /// Returns the trimmed value, or `fallback` when it's nil or blank.
    static func displayText(_ value: String?, fallback: String) -> String {
        guard let text = value?.trimmed, !text.isEmpty else {
            return fallback
        }
        return text
    }
}
