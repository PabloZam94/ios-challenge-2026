//
//  AddCatViewModelTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Testing
@testable import ApplaudoChallenge

@MainActor
struct AddCatViewModelTests {
    private let store = InMemoryCatStore()

    private func makeSUT() -> AddCatViewModel {
        AddCatViewModel(store: store)
    }

    private func fillValidForm(_ sut: AddCatViewModel) {
        sut.name = "Michi"
        sut.breed = "Siamese"
        sut.age = "3"
        sut.catDescription = "Loves boxes and long naps."
    }

    @Test func startsOnFirstStepWithoutVisibleErrors() {
        let sut = makeSUT()

        #expect(sut.currentStep == .basicInfo)
        #expect(sut.isFirstStep)
        #expect(sut.visibleErrors.isEmpty)
        #expect(!sut.isCurrentStepValid)
    }

    @Test func cannotAdvanceWithInvalidStepAndShowsInlineErrors() {
        let sut = makeSUT()

        sut.goToNextStep()

        #expect(sut.currentStep == .basicInfo)
        #expect(sut.error(for: .name) == "Name is required.")
        #expect(sut.error(for: .breed) == "Breed is required.")
        #expect(sut.error(for: .age) == nil)
    }

    @Test func errorsUpdateWhileTypingAfterFirstAttempt() {
        let sut = makeSUT()
        sut.goToNextStep()

        sut.name = "Michi"

        #expect(sut.error(for: .name) == nil)
        #expect(sut.error(for: .breed) != nil)
    }

    @Test func advancesWhenStepIsValid() {
        let sut = makeSUT()
        sut.name = "Michi"
        sut.breed = "Siamese"

        sut.goToNextStep()

        #expect(sut.currentStep == .details)
        #expect(sut.error(for: .age) == nil)
    }

    @Test func detailsStepValidatesAge() {
        let sut = makeSUT()
        sut.name = "Michi"
        sut.breed = "Siamese"
        sut.goToNextStep()
        sut.age = "-1"
        sut.catDescription = "Loves boxes and long naps."

        sut.goToNextStep()

        #expect(sut.currentStep == .details)
        #expect(sut.error(for: .age) == "Age must be a positive whole number.")
    }

    @Test func goesBackToPreviousStep() {
        let sut = makeSUT()
        fillValidForm(sut)
        sut.goToNextStep()

        sut.goToPreviousStep()

        #expect(sut.currentStep == .basicInfo)
    }

    @Test func savesCatAndResetsForm() throws {
        let sut = makeSUT()
        fillValidForm(sut)
        sut.goToNextStep()
        sut.goToNextStep()
        #expect(sut.isLastStep)

        sut.primaryAction()

        let saved = try #require(store.cats.first)
        #expect(saved.name == "Michi")
        #expect(saved.breed == "Siamese")
        #expect(saved.age == 3)
        #expect(sut.alert == .saved(name: "Michi"))
        #expect(sut.currentStep == .basicInfo)
        #expect(sut.name.isEmpty)
        #expect(sut.visibleErrors.isEmpty)
    }

    @Test func trimsValuesBeforeSaving() throws {
        let sut = makeSUT()
        fillValidForm(sut)
        sut.name = "  Michi  "
        sut.age = " 3 "

        sut.saveCat()

        let saved = try #require(store.cats.first)
        #expect(saved.name == "Michi")
        #expect(saved.age == 3)
    }

    @Test func doesNotSaveInvalidForm() {
        let sut = makeSUT()
        sut.name = "Michi"

        sut.saveCat()

        #expect(store.cats.isEmpty)
        #expect(sut.alert == nil)
        #expect(sut.error(for: .description) != nil)
    }

    @Test func showsFailureAlertWhenStoreFails() {
        store.shouldFail = true
        let sut = makeSUT()
        fillValidForm(sut)

        sut.saveCat()

        #expect(sut.alert == .saveFailed)
        #expect(sut.name == "Michi")
    }

    @Test func dismissingAlertClearsIt() {
        let sut = makeSUT()
        fillValidForm(sut)
        sut.saveCat()

        sut.isShowingAlert = false

        #expect(sut.alert == nil)
    }
}
