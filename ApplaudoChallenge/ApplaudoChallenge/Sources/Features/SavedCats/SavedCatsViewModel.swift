//
//  SavedCatsViewModel.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

@MainActor
final class SavedCatsViewModel: ObservableObject {
    @Published private(set) var cats: [SavedCat] = []
    @Published private(set) var errorMessage: String?

    private let store: CatStoreType

    init(store: CatStoreType) {
        self.store = store
    }

    func load() {
        do {
            cats = try store.fetchCats().sorted { $0.createdAt > $1.createdAt }
            errorMessage = nil
        } catch {
            errorMessage = "We couldn't load your saved cats."
        }
    }
}
