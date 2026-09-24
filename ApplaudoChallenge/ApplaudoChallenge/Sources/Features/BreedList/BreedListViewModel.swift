//
//  BreedListViewModel.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine
import Foundation
import NetworkLayer

@MainActor
final class BreedListViewModel: ObservableObject {
    @Published private(set) var breeds: [CatBreed] = []
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var isLoadingNextPage = false
    @Published private(set) var nextPageErrorMessage: String?

    private let service: CatBreedServiceType
    private let pageSize: Int
    private let scheduler: any Scheduler
    private var nextPage = 0
    private var canLoadMore = true
    private var request: AnyCancellable?

    init(
        service: CatBreedServiceType,
        pageSize: Int = 10,
        scheduler: any Scheduler = DispatchQueue.main
    ) {
        self.service = service
        self.pageSize = pageSize
        self.scheduler = scheduler
    }

    func loadIfNeeded() {
        guard state == .idle else { return }
        reload()
    }

    func reload() {
        request?.cancel()
        breeds = []
        nextPage = 0
        canLoadMore = true
        isLoadingNextPage = false
        nextPageErrorMessage = nil
        state = .loading
        fetchNextPage()
    }

    /// Triggers the next page once the last loaded breed becomes visible.
    func loadMoreIfNeeded(currentBreed breed: CatBreed) {
        guard let id = breed.id,
              id == breeds.last?.id,
              nextPageErrorMessage == nil else { return }
        loadNextPage()
    }

    func loadNextPage() {
        guard state == .loaded, canLoadMore, !isLoadingNextPage else { return }
        isLoadingNextPage = true
        nextPageErrorMessage = nil
        fetchNextPage()
    }

    private func fetchNextPage() {
        request = service.fetchBreeds(page: nextPage, limit: pageSize)
            .receive(onScheduler: scheduler)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.handleFailure(error)
            } receiveValue: { [weak self] page in
                self?.handleSuccess(page)
            }
    }

    private func handleSuccess(_ page: [CatBreed]) {
        let loadedIDs = Set(breeds.compactMap(\.id))
        let newBreeds = page.filter { breed in
            guard let id = breed.id else { return false }
            return !loadedIDs.contains(id)
        }
        breeds.append(contentsOf: newBreeds)
        nextPage += 1
        canLoadMore = page.count == pageSize
        isLoadingNextPage = false
        state = breeds.isEmpty ? .empty : .loaded
    }

    private func handleFailure(_ error: NetworkError) {
        isLoadingNextPage = false
        if breeds.isEmpty {
            state = .failed(message: error.userMessage)
        } else {
            nextPageErrorMessage = error.userMessage
        }
    }
}
