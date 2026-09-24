//
//  CatFormValidator.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

struct CatFormValidator {
    static let nameMinLength = 2
    static let descriptionMinLength = 10
    static let descriptionMaxLength = 200
    static let maxAge = 30

    func validate(name: String, breed: String, age: String, description: String) -> [CatFormField: String] {
        var errors: [CatFormField: String] = [:]
        errors[.name] = validateName(name)
        errors[.breed] = validateBreed(breed)
        errors[.age] = validateAge(age)
        errors[.description] = validateDescription(description)
        return errors
    }

    func validateName(_ value: String) -> String? {
        let name = value.trimmed
        if name.isEmpty {
            return "Name is required."
        }
        if name.count < Self.nameMinLength {
            return "Name must have at least \(Self.nameMinLength) characters."
        }
        return nil
    }

    func validateBreed(_ value: String) -> String? {
        value.trimmed.isEmpty ? "Breed is required." : nil
    }

    func validateAge(_ value: String) -> String? {
        let age = value.trimmed
        if age.isEmpty {
            return "Age is required."
        }
        guard let years = Int(age), years > 0 else {
            return "Age must be a positive whole number."
        }
        if years > Self.maxAge {
            return "Age must be \(Self.maxAge) or less."
        }
        return nil
    }

    func validateDescription(_ value: String) -> String? {
        let description = value.trimmed
        if description.isEmpty {
            return "Description is required."
        }
        if description.count < Self.descriptionMinLength {
            return "Description must have at least \(Self.descriptionMinLength) characters."
        }
        if description.count > Self.descriptionMaxLength {
            return "Description must have at most \(Self.descriptionMaxLength) characters."
        }
        return nil
    }
}
