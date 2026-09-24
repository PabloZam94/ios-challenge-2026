//
//  CatStore.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

protocol CatStoreType {
    func fetchCats() throws -> [SavedCat]
    func save(_ cat: SavedCat) throws
}

/// Persists cats as a JSON file in Application Support so they survive app restarts.
final class FileCatStore: CatStoreType {
    static let defaultFileURL = URL.applicationSupportDirectory.appending(path: "saved_cats.json")

    private let fileURL: URL
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileURL: URL = FileCatStore.defaultFileURL, fileManager: FileManager = .default) {
        self.fileURL = fileURL
        self.fileManager = fileManager
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func fetchCats() throws -> [SavedCat] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([SavedCat].self, from: data)
    }

    func save(_ cat: SavedCat) throws {
        let cats = try fetchCats() + [cat]
        try fileManager.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try encoder.encode(cats).write(to: fileURL, options: .atomic)
    }
}
