//
//  PersistenceTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
import Testing
@testable import ApplaudoChallenge

struct FileCatStoreTests {
    private let fileURL = FileManager.default.temporaryDirectory
        .appending(path: UUID().uuidString)
        .appending(path: "cats.json")

    @Test func returnsEmptyListWhenNothingWasSaved() throws {
        #expect(try FileCatStore(fileURL: fileURL).fetchCats().isEmpty)
    }

    @Test func persistsCatsAcrossInstances() throws {
        let first = SavedCat(name: "Michi", breed: "Siamese", age: 3, description: "Loves boxes.")
        let second = SavedCat(name: "Luna", breed: "Persian", age: 1, description: "Sleeps all day.")

        try FileCatStore(fileURL: fileURL).save(first)
        try FileCatStore(fileURL: fileURL).save(second)

        let cats = try FileCatStore(fileURL: fileURL).fetchCats()
        #expect(cats.map(\.id) == [first.id, second.id])
        #expect(cats.first?.name == "Michi")
    }

    @Test func summaryPluralizesAge() {
        #expect(SavedCat.summary(breed: "Siamese", age: 1) == "Siamese · 1 year old")
        #expect(SavedCat.summary(breed: "Siamese", age: 4) == "Siamese · 4 years old")
    }
}

@MainActor
struct SavedCatsViewModelTests {

    @Test func loadsCatsNewestFirst() {
        let older = SavedCat(name: "Old", breed: "Manx", age: 9, description: "Wise cat.", createdAt: Date(timeIntervalSince1970: 0))
        let newer = SavedCat(name: "New", breed: "Bengal", age: 1, description: "Tiny cat.", createdAt: Date())
        let sut = SavedCatsViewModel(store: InMemoryCatStore(cats: [older, newer]))

        sut.load()

        #expect(sut.cats == [newer, older])
        #expect(sut.errorMessage == nil)
    }

    @Test func exposesErrorWhenLoadingFails() {
        let store = InMemoryCatStore()
        store.shouldFail = true
        let sut = SavedCatsViewModel(store: store)

        sut.load()

        #expect(sut.errorMessage != nil)
    }
}
