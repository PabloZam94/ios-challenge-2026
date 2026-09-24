//
//  BreedDetailViewModelTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
import NetworkLayer
import Testing
@testable import ApplaudoChallenge

struct BreedDetailViewModelTests {
    private let breed = CatBreed(
        id: "abys",
        name: "Abyssinian",
        description: "Curious and playful.",
        origin: "Egypt",
        temperament: "Active, Energetic , , Independent",
        lifeSpan: "14 - 15",
        referenceImageId: "0XYvRd7oD"
    )

    @Test func exposesBreedInformation() {
        let sut = BreedDetailViewModel(breed: breed)

        #expect(sut.name == "Abyssinian")
        #expect(sut.description == "Curious and playful.")
        #expect(sut.origin == "Egypt")
        #expect(sut.imageURL == breed.imageURL)
    }

    @Test func formatsLifeSpanInYears() {
        #expect(BreedDetailViewModel(breed: breed).lifeSpan == "14 - 15 years")
    }

    @Test func showsFallbacksForMissingData() {
        let sut = BreedDetailViewModel(
            breed: CatBreed(id: "cara", name: "Caracat", description: "", origin: "", temperament: "", lifeSpan: "")
        )

        #expect(sut.description == "No description available.")
        #expect(sut.origin == "Unknown")
        #expect(sut.lifeSpan == "Unknown")
        #expect(sut.temperament == "Unknown")
    }

    @Test func showsFallbacksForNilData() {
        let sut = BreedDetailViewModel(breed: CatBreed(id: "unknown"))

        #expect(sut.name == "Unknown Breed")
        #expect(sut.description == "No description available.")
        #expect(sut.origin == "Unknown")
        #expect(sut.lifeSpan == "Unknown")
        #expect(sut.temperamentTraits.isEmpty)
        #expect(sut.temperament == "Unknown")
    }

    @Test func splitsTemperamentIntoTrimmedTraits() {
        let sut = BreedDetailViewModel(breed: breed)

        #expect(sut.temperamentTraits == ["Active", "Energetic", "Independent"])
        #expect(sut.temperament == "Active · Energetic · Independent")
    }
}
