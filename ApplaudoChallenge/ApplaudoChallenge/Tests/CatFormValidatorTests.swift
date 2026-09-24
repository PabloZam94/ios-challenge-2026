//
//  CatFormValidatorTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Testing
@testable import ApplaudoChallenge

struct CatFormValidatorTests {
    private let sut = CatFormValidator()

    @Test func validFormHasNoErrors() {
        let errors = sut.validate(name: "Michi",
                                  breed: "Siamese",
                                  age: "3",
                                  description: "Loves boxes and naps.")

        #expect(errors.isEmpty)
    }

    @Test(arguments: ["", "   "])
    func nameIsRequired(_ name: String) {
        #expect(sut.validateName(name) == "Name is required.")
    }

    @Test func nameNeedsMinimumLength() {
        #expect(sut.validateName("M") != nil)
        #expect(sut.validateName(" Mi ") == nil)
    }

    @Test func breedIsRequired() {
        #expect(sut.validateBreed("  ") == "Breed is required.")
        #expect(sut.validateBreed("Persian") == nil)
    }

    @Test func ageIsRequired() {
        #expect(sut.validateAge("") == "Age is required.")
    }

    @Test(arguments: ["0", "-2", "abc", "2.5"])
    func ageMustBePositiveWholeNumber(_ age: String) {
        #expect(sut.validateAge(age) == "Age must be a positive whole number.")
    }

    @Test func ageHasUpperBound() {
        #expect(sut.validateAge("\(CatFormValidator.maxAge)") == nil)
        #expect(sut.validateAge("\(CatFormValidator.maxAge + 1)") != nil)
    }

    @Test func descriptionLengthIsValidated() {
        let tooLong = String(repeating: "a", count: CatFormValidator.descriptionMaxLength + 1)

        #expect(sut.validateDescription("") == "Description is required.")
        #expect(sut.validateDescription("Too short") != nil)
        #expect(sut.validateDescription(tooLong) != nil)
        #expect(sut.validateDescription("A calm and friendly cat.") == nil)
    }
}
