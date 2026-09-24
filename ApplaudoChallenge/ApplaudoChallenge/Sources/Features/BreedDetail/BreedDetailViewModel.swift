//
//  BreedDetailViewModel.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
import NetworkLayer

struct BreedDetailViewModel {
    private let breed: CatBreed

    init(breed: CatBreed) {
        self.breed = breed
    }

    var name: String { breed.displayName }
    var imageURL: URL? { breed.imageURL }
    var description: String { breed.displayDescription }
    var origin: String { CatBreed.displayText(breed.origin, fallback: "Unknown") }

    var lifeSpan: String {
        guard let lifeSpan = breed.lifeSpan?.trimmed, !lifeSpan.isEmpty else {
            return "Unknown"
        }
        return "\(lifeSpan) years"
    }

    var temperamentTraits: [String] {
        guard let temperament = breed.temperament else {
            return []
        }
        return temperament
            .split(separator: ",")
            .map { String($0).trimmed }
            .filter { !$0.isEmpty }
    }

    var temperament: String {
        temperamentTraits.isEmpty ? "Unknown" : temperamentTraits.joined(separator: " · ")
    }
}
