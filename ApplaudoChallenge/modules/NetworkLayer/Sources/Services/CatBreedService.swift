//
//  CatBreedService.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine
import Foundation

// MARK: - Cat Breed Service Type
public protocol CatBreedServiceType {
    func fetchBreeds(page: Int, limit: Int) -> AnyPublisher<[CatBreed], NetworkError>
}

// MARK: - Cat Breed Service
public struct CatBreedService: CatBreedServiceType {
    private let requester: NetworkingRequesterType

    public init(environment: NetworkEnvironment) {
        self.init(requester: environment.makeRequester())
    }

    init(requester: NetworkingRequesterType) {
        self.requester = requester
    }

    public func fetchBreeds(page: Int, limit: Int) -> AnyPublisher<[CatBreed], NetworkError> {
        let response: AnyPublisher<[LossyDecodable<CatBreed>], NetworkError> = requester.execute(
            request: CatBreedsTarget.getBreeds(page: page, limit: limit)
        )

        return response
            .map { items in
                items.compactMap { item in
                    // A breed without id can't be identified in lists or navigation.
                    guard let breed = item.value, breed.id != nil else { return nil }
                    return breed
                }
            }
            .eraseToAnyPublisher()
    }
}
