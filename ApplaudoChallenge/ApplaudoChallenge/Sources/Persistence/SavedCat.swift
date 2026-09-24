//
//  SavedCat.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

struct SavedCat: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let breed: String
    let age: Int
    let description: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        breed: String,
        age: Int,
        description: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.age = age
        self.description = description
        self.createdAt = createdAt
    }

    var summary: String {
        Self.summary(breed: breed, age: age)
    }

    static func summary(breed: String, age: Int) -> String {
        "\(breed) · \(age) \(age == 1 ? "year" : "years") old"
    }
}
