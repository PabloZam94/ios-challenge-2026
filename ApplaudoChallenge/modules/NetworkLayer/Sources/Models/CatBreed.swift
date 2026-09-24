//
//  CatBreed.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation

// MARK: - Cat Breed
public struct CatBreed: Codable, Identifiable, Hashable, Sendable {
    public let id: String?
    public let name: String?
    public let description: String?
    public let origin: String?
    public let temperament: String?
    public let lifeSpan: String?
    public let referenceImageId: String?
    public let image: CatImage?

    public init(
        id: String? = nil,
        name: String? = nil,
        description: String? = nil,
        origin: String? = nil,
        temperament: String? = nil,
        lifeSpan: String? = nil,
        referenceImageId: String? = nil,
        image: CatImage? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.origin = origin
        self.temperament = temperament
        self.lifeSpan = lifeSpan
        self.referenceImageId = referenceImageId
        self.image = image
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description, origin, temperament, image
        case lifeSpan = "life_span"
        case referenceImageId = "reference_image_id"
    }

    /// Prefers the embedded image and falls back to the CDN path built from `referenceImageId`.
    public var imageURL: URL? {
        if let url = image?.url {
            return url
        }
        guard let referenceImageId else {
            return nil
        }
        return URL(string: "https://cdn2.thecatapi.com/images/\(referenceImageId).jpg")
    }
}

// MARK: - Cat Image
public struct CatImage: Codable, Hashable, Sendable {
    public let id: String?
    public let url: URL?

    public init(id: String? = nil, url: URL?) {
        self.id = id
        self.url = url
    }
}
