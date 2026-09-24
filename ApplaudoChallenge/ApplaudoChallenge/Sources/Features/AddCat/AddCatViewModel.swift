//
//  AddCatViewModel.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine
import Foundation

enum AddCatAlert: Equatable {
    case saved(name: String)
    case saveFailed

    var title: String {
        switch self {
        case .saved: return "Cat Saved"
        case .saveFailed: return "Couldn't Save"
        }
    }

    var message: String {
        switch self {
        case .saved(let name): return "\(name) was added to your cats."
        case .saveFailed: return "Something went wrong while saving your cat. Please try again."
        }
    }
}

@MainActor
final class AddCatViewModel: ObservableObject {
    @Published var name = ""
    @Published var breed = ""
    @Published var age = ""
    @Published var catDescription = ""

    @Published private(set) var currentStep: AddCatStep = .basicInfo
    @Published private(set) var visibleErrors: [CatFormField: String] = [:]
    @Published private(set) var isCurrentStepValid = false
    @Published var alert: AddCatAlert?

    @Published private var validationErrors: [CatFormField: String] = [:]
    /// Errors are only shown for steps the user already tried to submit.
    @Published private var attemptedSteps: Set<AddCatStep> = []

    private let store: CatStoreType
    private let validator: CatFormValidator

    init(store: CatStoreType, validator: CatFormValidator = CatFormValidator()) {
        self.store = store
        self.validator = validator
        bindValidation()
    }

    var steps: [AddCatStep] { AddCatStep.allCases }
    var isFirstStep: Bool { currentStep.previous == nil }
    var isLastStep: Bool { currentStep.next == nil }
    var primaryButtonTitle: String { isLastStep ? "Save Cat" : "Next" }
    var reviewSummary: String { SavedCat.summary(breed: breed.trimmed, age: Int(age.trimmed) ?? 0) }

    var isShowingAlert: Bool {
        get { alert != nil }
        set { if !newValue { alert = nil } }
    }

    func error(for field: CatFormField) -> String? {
        visibleErrors[field]
    }

    func primaryAction() {
        isLastStep ? saveCat() : goToNextStep()
    }

    func goToNextStep() {
        attemptedSteps.insert(currentStep)
        guard isCurrentStepValid, let next = currentStep.next else { return }
        currentStep = next
    }

    func goToPreviousStep() {
        guard let previous = currentStep.previous else { return }
        currentStep = previous
    }

    func saveCat() {
        attemptedSteps = Set(AddCatStep.allCases)
        guard validationErrors.isEmpty, let years = Int(age.trimmed) else { return }

        let cat = SavedCat(
            name: name.trimmed,
            breed: breed.trimmed,
            age: years,
            description: catDescription.trimmed
        )

        do {
            try store.save(cat)
            alert = .saved(name: cat.name)
            reset()
        } catch {
            alert = .saveFailed
        }
    }

    func makeSavedCatsViewModel() -> SavedCatsViewModel {
        SavedCatsViewModel(store: store)
    }

    private func reset() {
        name = ""
        breed = ""
        age = ""
        catDescription = ""
        attemptedSteps = []
        currentStep = .basicInfo
    }

    private func bindValidation() {
        Publishers.CombineLatest4($name, $breed, $age, $catDescription)
            .map { [validator] name, breed, age, description in
                validator.validate(name: name, breed: breed, age: age, description: description)
            }
            .assign(to: &$validationErrors)

        $validationErrors
            .combineLatest($attemptedSteps)
            .map { errors, attemptedSteps in
                errors.filter { field, _ in
                    attemptedSteps.contains { $0.fields.contains(field) }
                }
            }
            .assign(to: &$visibleErrors)

        $validationErrors
            .combineLatest($currentStep)
            .map { errors, step in
                step.fields.allSatisfy { errors[$0] == nil }
            }
            .assign(to: &$isCurrentStepValid)
    }
}
