//
//  BreedDetailView.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import NetworkLayer
import SwiftUI

struct BreedDetailView: View {
    let viewModel: BreedDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                breedImage

                Text(viewModel.name)
                    .font(AppTheme.Fonts.largeTitle)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    SectionHeader(title: "About", systemImage: "text.alignleft")
                    Text(viewModel.description)
                        .font(AppTheme.Fonts.body)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }

                SectionHeader(title: "Origin",
                              subtitle: viewModel.origin,
                              systemImage: "globe")
                SectionHeader(title: "Life Span",
                              subtitle: viewModel.lifeSpan,
                              systemImage: "heart")
                SectionHeader(title: "Temperament",
                              subtitle: viewModel.temperament,
                              systemImage: "sparkles")
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
        .navigationTitle(viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var breedImage: some View {
        Rectangle()
            .fill(AppTheme.Colors.surface)
            .frame(height: 260)
            .overlay {
                AsyncImage(url: viewModel.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty where viewModel.imageURL != nil:
                        ProgressView()
                    default:
                        imagePlaceholder
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
            .accessibilityLabel("Photo of a \(viewModel.name) cat")
    }

    private var imagePlaceholder: some View {
        Image(systemName: "cat")
            .font(.system(size: 64))
            .foregroundColor(AppTheme.Colors.textSecondary.opacity(0.5))
    }
}

// MARK: - Preview

#Preview("Breed Detail") {
    NavigationStack {
        BreedDetailView(viewModel: BreedDetailViewModel(breed: CatBreedMocks.breeds[0]))
    }
}
