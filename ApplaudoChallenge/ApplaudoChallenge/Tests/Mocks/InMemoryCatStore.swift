//
//  InMemoryCatStore.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
@testable import ApplaudoChallenge

final class InMemoryCatStore: CatStoreType {
    struct StoreError: Error {}

    var cats: [SavedCat]
    var shouldFail = false

    init(cats: [SavedCat] = []) {
        self.cats = cats
    }

    func fetchCats() throws -> [SavedCat] {
        if shouldFail { throw StoreError() }
        return cats
    }

    func save(_ cat: SavedCat) throws {
        if shouldFail { throw StoreError() }
        cats.append(cat)
    }
}
