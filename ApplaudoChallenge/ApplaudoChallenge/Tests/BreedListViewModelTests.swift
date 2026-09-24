//
//  BreedListViewModelTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine
import Foundation
import NetworkLayer
import Testing
@testable import ApplaudoChallenge

@MainActor
struct BreedListViewModelTests {
    private let breeds = Array(CatBreedMocks.breeds.prefix(5))
    private let service = MockCatBreedService()

    private func makeSUT(pageSize: Int = 2) -> BreedListViewModel {
        BreedListViewModel(service: service, pageSize: pageSize, scheduler: ImmediateScheduler.shared)
    }

    @Test func initialStateIsIdle() {
        let sut = makeSUT()

        #expect(sut.state == .idle)
        #expect(sut.breeds.isEmpty)
    }

    @Test func showsLoadingWhileFirstPageIsPending() {
        service.pendingSubject = PassthroughSubject()
        let sut = makeSUT()

        sut.loadIfNeeded()

        #expect(sut.state == .loading)
    }

    @Test func loadsFirstPage() {
        service.results[0] = .success(Array(breeds[0..<2]))
        let sut = makeSUT()

        sut.loadIfNeeded()

        #expect(sut.state == .loaded)
        #expect(sut.breeds == Array(breeds[0..<2]))
        #expect(service.requestedPages == [0])
    }

    @Test func loadIfNeededOnlyLoadsOnce() {
        service.results[0] = .success(Array(breeds[0..<2]))
        let sut = makeSUT()

        sut.loadIfNeeded()
        sut.loadIfNeeded()

        #expect(service.requestedPages == [0])
    }

    @Test func showsEmptyStateWhenThereAreNoBreeds() {
        service.results[0] = .success([])
        let sut = makeSUT()

        sut.loadIfNeeded()

        #expect(sut.state == .empty)
    }

    @Test func showsErrorWhenFirstPageFails() {
        let error = NetworkError.serverError(statusCode: 500, data: Data())
        service.results[0] = .failure(error)
        let sut = makeSUT()

        sut.loadIfNeeded()

        #expect(sut.state == .failed(message: error.userMessage))
        #expect(sut.breeds.isEmpty)
    }

    @Test func reloadRecoversFromError() {
        service.results[0] = .failure(.serverError(statusCode: 500, data: Data()))
        let sut = makeSUT()
        sut.loadIfNeeded()

        service.results[0] = .success(Array(breeds[0..<2]))
        sut.reload()

        #expect(sut.state == .loaded)
        #expect(sut.breeds.count == 2)
    }

    @Test func loadsNextPageWhenLastBreedAppears() {
        service.results[0] = .success(Array(breeds[0..<2]))
        service.results[1] = .success(Array(breeds[2..<4]))
        let sut = makeSUT()
        sut.loadIfNeeded()

        sut.loadMoreIfNeeded(currentBreed: breeds[1])

        #expect(sut.breeds == Array(breeds[0..<4]))
        #expect(service.requestedPages == [0, 1])
    }

    @Test func ignoresItemsThatAreNotTheLastOne() {
        service.results[0] = .success(Array(breeds[0..<2]))
        let sut = makeSUT()
        sut.loadIfNeeded()

        sut.loadMoreIfNeeded(currentBreed: breeds[0])

        #expect(service.requestedPages == [0])
    }

    @Test func stopsPaginatingAfterAShortPage() {
        service.results[0] = .success(Array(breeds[0..<2]))
        service.results[1] = .success([breeds[2]])
        let sut = makeSUT()
        sut.loadIfNeeded()
        sut.loadNextPage()

        sut.loadNextPage()

        #expect(service.requestedPages == [0, 1])
        #expect(sut.breeds.count == 3)
    }

    @Test func ignoresDuplicatedBreedsAcrossPages() {
        service.results[0] = .success(Array(breeds[0..<2]))
        service.results[1] = .success([breeds[1], breeds[2]])
        let sut = makeSUT()
        sut.loadIfNeeded()

        sut.loadNextPage()

        #expect(sut.breeds.map(\.id) == breeds[0..<3].map(\.id))
    }

    @Test func keepsBreedsVisibleWhileNextPageIsLoading() {
        service.results[0] = .success(Array(breeds[0..<2]))
        let sut = makeSUT()
        sut.loadIfNeeded()
        service.pendingSubject = PassthroughSubject()

        sut.loadNextPage()

        #expect(sut.isLoadingNextPage)
        #expect(sut.state == .loaded)
        #expect(sut.breeds.count == 2)
    }

    @Test func nextPageFailureKeepsLoadedBreeds() {
        let error = NetworkError.unknown(underlying: URLError(.notConnectedToInternet))
        service.results[0] = .success(Array(breeds[0..<2]))
        service.results[1] = .failure(error)
        let sut = makeSUT()
        sut.loadIfNeeded()

        sut.loadNextPage()

        #expect(sut.state == .loaded)
        #expect(sut.breeds.count == 2)
        #expect(sut.nextPageErrorMessage == error.userMessage)
        #expect(!sut.isLoadingNextPage)
    }

    @Test func retryAfterNextPageFailureAppendsBreeds() {
        service.results[0] = .success(Array(breeds[0..<2]))
        service.results[1] = .failure(.serverError(statusCode: 503, data: Data()))
        let sut = makeSUT()
        sut.loadIfNeeded()
        sut.loadNextPage()

        service.results[1] = .success(Array(breeds[2..<4]))
        sut.loadNextPage()

        #expect(sut.breeds.count == 4)
        #expect(sut.nextPageErrorMessage == nil)
    }

    @Test func worksEndToEndWithMockEnvironment() async throws {
        let sut = BreedListViewModel(
            service: CatBreedService(environment: .mock(delay: 0)),
            pageSize: 10,
            scheduler: ImmediateScheduler.shared
        )

        sut.loadIfNeeded()
        for await state in sut.$state.values where state != .loading {
            #expect(state == .loaded)
            break
        }

        #expect(sut.breeds == Array(CatBreedMocks.breeds.prefix(10)))
    }
}
