//
//  MockCatBreedService.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine
import Foundation
import NetworkLayer
@testable import ApplaudoChallenge

final class MockCatBreedService: CatBreedServiceType {
    /// Result per page; pages without an entry return an empty list.
    var results: [Int: Result<[CatBreed], NetworkError>] = [:]
    /// When set, requests stay pending until the subject emits.
    var pendingSubject: PassthroughSubject<[CatBreed], NetworkError>?
    private(set) var requestedPages: [Int] = []

    func fetchBreeds(page: Int, limit: Int) -> AnyPublisher<[CatBreed], NetworkError> {
        requestedPages.append(page)
        if let pendingSubject {
            return pendingSubject.eraseToAnyPublisher()
        }
        return (results[page] ?? .success([])).publisher.eraseToAnyPublisher()
    }
}
