//
//  AddCatStepperView.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import SwiftUI

struct AddCatStepperView: View {
    @StateObject private var viewModel: AddCatViewModel
    @State private var isShowingSavedCats = false

    init(viewModel: @autoclosure @escaping () -> AddCatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            StepperIndicator(
                currentStep: viewModel.currentStep.rawValue,
                totalSteps: viewModel.steps.count,
                stepTitles: viewModel.steps.map(\.title)
            )
            .padding(.top, AppTheme.Spacing.md)

            ScrollView {
                stepContent
                    .padding(.horizontal, AppTheme.Spacing.md)
            }
            .scrollDismissesKeyboard(.interactively)

            navigationButtons
                .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Colors.background)
        .navigationTitle("Add Cat")
        .animation(.easeInOut, value: viewModel.currentStep)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingSavedCats = true
                } label: {
                    Image(systemName: "list.bullet")
                }
                .accessibilityLabel("Saved cats")
            }
        }
        .sheet(isPresented: $isShowingSavedCats) {
            NavigationStack {
                SavedCatsView(viewModel: viewModel.makeSavedCatsViewModel())
            }
        }
        .alert(
            viewModel.alert?.title ?? "",
            isPresented: $viewModel.isShowingAlert,
            presenting: viewModel.alert
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { alert in
            Text(alert.message)
        }
    }

    // MARK: - Steps

    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case .basicInfo:
            basicInfoStep
        case .details:
            detailsStep
        case .review:
            reviewStep
        }
    }

    private var basicInfoStep: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            SectionHeader(title: "Basic Info",
                          subtitle: "Tell us who your cat is",
                          systemImage: "info.circle")

            AppTextField(
                label: "Name",
                placeholder: "e.g. Michi",
                text: $viewModel.name,
                errorMessage: viewModel.error(for: .name),
                icon: "textformat"
            )

            AppTextField(
                label: "Breed",
                placeholder: "e.g. Siamese",
                text: $viewModel.breed,
                errorMessage: viewModel.error(for: .breed),
                icon: "cat"
            )
        }
    }

    private var detailsStep: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            SectionHeader(title: "Details",
                          subtitle: "Age and a short description",
                          systemImage: "list.bullet.rectangle")

            AppTextField(
                label: "Age (years)",
                placeholder: "e.g. 3",
                text: $viewModel.age,
                errorMessage: viewModel.error(for: .age),
                keyboardType: .numberPad,
                icon: "calendar"
            )

            AppTextField(
                label: "Description",
                placeholder: "Personality, habits, favorite toys…",
                text: $viewModel.catDescription,
                errorMessage: viewModel.error(for: .description),
                icon: "text.alignleft"
            )
        }
    }

    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            SectionHeader(title: "Review", subtitle: "Make sure everything looks right", systemImage: "checkmark.seal")

            AppCard(
                title: viewModel.name.trimmed,
                subtitle: viewModel.reviewSummary,
                imageSystemName: "cat.fill",
                showChevron: false
            )

            Text(viewModel.catDescription.trimmed)
                .font(AppTheme.Fonts.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }

    // MARK: - Buttons

    private var navigationButtons: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            if !viewModel.isFirstStep {
                AppButton(title: "Back", style: .secondary) {
                    viewModel.goToPreviousStep()
                }
            }

            AppButton(title: viewModel.primaryButtonTitle) {
                viewModel.primaryAction()
            }
        }
    }
}

// MARK: - Preview

#Preview("Add Cat") {
    NavigationStack {
        AddCatStepperView(viewModel: AddCatViewModel(store: FileCatStore()))
    }
}
