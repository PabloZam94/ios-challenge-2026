//
//  NetworkLayerTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine
import Foundation
import Moya
import Testing
@testable import NetworkLayer

// MARK: - Test Doubles

final class MockNetworkingRequester: NetworkingRequesterType {
    private let result: Result<Data, NetworkError>
    private(set) var receivedRequests: [NetworkingTargetType] = []

    init(result: Result<Data, NetworkError>) {
        self.result = result
    }

    func execute(request: NetworkingTargetType) -> AnyPublisher<Data, NetworkError> {
        receivedRequests.append(request)
        return result.publisher.eraseToAnyPublisher()
    }
}

enum PublisherTestError: Error {
    case finishedWithoutValue
}

extension Publisher {
    func firstValue() async throws -> Output {
        for try await value in values {
            return value
        }
        throw PublisherTestError.finishedWithoutValue
    }
}

// MARK: - CatBreedService Tests

struct CatBreedServiceTests {

    @Test func fetchBreedsDecodesResponse() async throws {
        let expected = Array(CatBreedMocks.breeds.prefix(3))
        let requester = MockNetworkingRequester(result: .success(try JSONEncoder().encode(expected)))
        let service = CatBreedService(requester: requester)

        let breeds = try await service.fetchBreeds(page: 0, limit: 3).firstValue()

        #expect(breeds == expected)
    }

    @Test func fetchBreedsRequestsBreedsTarget() async throws {
        let requester = MockNetworkingRequester(result: .success(Data("[]".utf8)))
        let service = CatBreedService(requester: requester)

        _ = try await service.fetchBreeds(page: 2, limit: 15).firstValue()

        let target = try #require(requester.receivedRequests.first as? CatBreedsTarget)
        #expect(target.path == "breeds")
        #expect(target.requestMethod == .get)
        guard case let .requestParameters(parameters, _) = target.task else {
            Issue.record("Expected query parameters")
            return
        }
        #expect(parameters["page"] as? Int == 2)
        #expect(parameters["limit"] as? Int == 15)
    }

    @Test func fetchBreedsPropagatesServerError() async {
        let requester = MockNetworkingRequester(result: .failure(.serverError(statusCode: 500, data: Data())))
        let service = CatBreedService(requester: requester)

        let error = await #expect(throws: NetworkError.self) {
            try await service.fetchBreeds(page: 0, limit: 10).firstValue()
        }

        guard case .serverError(let statusCode, _)? = error else {
            Issue.record("Expected serverError, got \(String(describing: error))")
            return
        }
        #expect(statusCode == 500)
    }

    @Test func fetchBreedsMapsInvalidPayloadToDecodingError() async {
        let requester = MockNetworkingRequester(result: .success(Data("{\"invalid\": true}".utf8)))
        let service = CatBreedService(requester: requester)

        let error = await #expect(throws: NetworkError.self) {
            try await service.fetchBreeds(page: 0, limit: 10).firstValue()
        }

        guard case .decodingFailed? = error else {
            Issue.record("Expected decodingFailed, got \(String(describing: error))")
            return
        }
    }

    @Test func fetchBreedsSkipsMalformedElements() async throws {
        let json = """
        [
            {"id": "bure", "name": "Burmese", "origin": "Myanmar"},
            {"id": 42, "name": null},
            {"name": "No identifier"},
            {"id": "cara", "name": "Caracat", "origin": null}
        ]
        """
        let requester = MockNetworkingRequester(result: .success(Data(json.utf8)))
        let service = CatBreedService(requester: requester)

        let breeds = try await service.fetchBreeds(page: 0, limit: 10).firstValue()

        #expect(breeds.map(\.id) == ["bure", "cara"])
    }

    @Test func mockEnvironmentServesPaginatedSampleData() async throws {
        let service = CatBreedService(environment: .mock(delay: 0))
        let pageSize = 10
        let lastPage = (CatBreedMocks.breeds.count - 1) / pageSize

        let firstPage = try await service.fetchBreeds(page: 0, limit: pageSize).firstValue()
        let finalPage = try await service.fetchBreeds(page: lastPage, limit: pageSize).firstValue()
        let beyondLastPage = try await service.fetchBreeds(page: lastPage + 1, limit: pageSize).firstValue()

        #expect(firstPage == Array(CatBreedMocks.breeds.prefix(pageSize)))
        #expect(finalPage.count == CatBreedMocks.breeds.count - lastPage * pageSize)
        #expect(beyondLastPage.isEmpty)
    }
}

// MARK: - CatBreed Tests

struct CatBreedTests {

    @Test func decodesSnakeCaseKeys() throws {
        let json = """
        {
            "id": "abys",
            "name": "Abyssinian",
            "description": "Playful",
            "origin": "Egypt",
            "temperament": "Active, Energetic",
            "life_span": "14 - 15",
            "reference_image_id": "0XYvRd7oD"
        }
        """

        let breed = try JSONDecoder().decode(CatBreed.self, from: Data(json.utf8))

        #expect(breed.lifeSpan == "14 - 15")
        #expect(breed.referenceImageId == "0XYvRd7oD")
        #expect(breed.imageURL == URL(string: "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"))
    }

    @Test func decodesMissingOrNullFieldsAsNil() throws {
        let json = """
        {"id": "cara", "name": "Caracat", "origin": null, "reference_image_id": null}
        """

        let breed = try JSONDecoder().decode(CatBreed.self, from: Data(json.utf8))

        #expect(breed.origin == nil)
        #expect(breed.temperament == nil)
        #expect(breed.description == nil)
        #expect(breed.lifeSpan == nil)
        #expect(breed.imageURL == nil)
    }

    @Test func imageURLPrefersEmbeddedImage() {
        let url = URL(string: "https://example.com/cat.png")
        let breed = CatBreed(
            id: "id", name: "Name", description: "", origin: "", temperament: "", lifeSpan: "",
            referenceImageId: "ref", image: CatImage(url: url)
        )

        #expect(breed.imageURL == url)
    }

    @Test func imageURLIsNilWithoutImageData() {
        let breed = CatBreed(id: "id", name: "Name", description: "", origin: "", temperament: "", lifeSpan: "")

        #expect(breed.imageURL == nil)
    }
}

// MARK: - CatBreedMocks Tests

struct CatBreedMocksTests {

    @Test(arguments: [(-1, 10), (0, 0), (100, 10)])
    func sliceReturnsEmptyForOutOfRangeInput(page: Int, limit: Int) {
        #expect(CatBreedMocks.slice(page: page, limit: limit).isEmpty)
    }

    @Test func pageDataRoundTrips() throws {
        let data = CatBreedMocks.pageData(page: 0, limit: 5)

        let breeds = try JSONDecoder().decode([CatBreed].self, from: data)

        #expect(breeds == Array(CatBreedMocks.breeds.prefix(5)))
    }
}
