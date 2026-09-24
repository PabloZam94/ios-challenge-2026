//
//  BreedListView.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import NetworkLayer
import SwiftUI

struct BreedListView: View {
    @StateObject private var viewModel: BreedListViewModel

    init(viewModel: @autoclosure @escaping () -> BreedListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.Colors.background)
            .navigationTitle("Cats")
            .navigationDestination(for: CatBreed.self) { breed in
                BreedDetailView(viewModel: BreedDetailViewModel(breed: breed))
            }
            .onAppear { viewModel.loadIfNeeded() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading breeds…")
        case .empty:
            EmptyStateView(
                systemImage: "cat",
                title: "No Breeds Found",
                message: "There are no cat breeds to show right now.",
                buttonTitle: "Reload",
                action: { viewModel.reload() }
            )
        case .failed(let message):
            EmptyStateView(
                systemImage: "exclamationmark.triangle",
                title: "Something Went Wrong",
                message: message,
                buttonTitle: "Try Again",
                action: { viewModel.reload() }
            )
        case .loaded:
            breedList
        }
    }

    private var breedList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(viewModel.breeds) { breed in
                    NavigationLink(value: breed) {
                        AppCard(
                            title: breed.displayName,
                            subtitle: breed.displayDescription,
                            imageSystemName: "cat",
                            subtitleLineLimit: 2,
                            imageURL: breed.imageURL
                        )
                    }
                    .buttonStyle(.plain)
                    .onAppear { viewModel.loadMoreIfNeeded(currentBreed: breed) }
                }

                pageFooter
            }
            .padding(AppTheme.Spacing.md)
        }
    }

    @ViewBuilder
    private var pageFooter: some View {
        if viewModel.isLoadingNextPage {
            ProgressView()
                .padding(AppTheme.Spacing.md)
        } else if let message = viewModel.nextPageErrorMessage {
            VStack(spacing: AppTheme.Spacing.sm) {
                Text(message)
                    .font(AppTheme.Fonts.caption)
                    .foregroundColor(AppTheme.Colors.error)
                    .multilineTextAlignment(.center)

                AppButton(title: "Retry", style: .secondary) {
                    viewModel.loadNextPage()
                }
            }
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }
}

// MARK: - Preview

#Preview("Breed List") {
    NavigationStack {
        BreedListView(viewModel: BreedListViewModel(service: CatBreedService(environment: .mock())))
    }
}
