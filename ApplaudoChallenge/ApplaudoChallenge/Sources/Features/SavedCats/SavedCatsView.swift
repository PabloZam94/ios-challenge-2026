//
//  SavedCatsView.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import SwiftUI

struct SavedCatsView: View {
    @StateObject private var viewModel: SavedCatsViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: @autoclosure @escaping () -> SavedCatsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppTheme.Colors.background)
            .navigationTitle("My Cats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear { viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        if let message = viewModel.errorMessage {
            EmptyStateView(
                systemImage: "exclamationmark.triangle",
                title: "Something Went Wrong",
                message: message,
                buttonTitle: "Try Again",
                action: { viewModel.load() }
            )
        } else if viewModel.cats.isEmpty {
            EmptyStateView(
                systemImage: "cat",
                title: "No Cats Yet",
                message: "The cats you register will appear here."
            )
        } else {
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.cats) { cat in
                        AppCard(
                            title: cat.name,
                            subtitle: cat.summary,
                            imageSystemName: "cat.fill",
                            showChevron: false
                        )
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
        }
    }
}
