//
//  AddCatStep.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

enum CatFormField: Hashable {
    case name
    case breed
    case age
    case description
}

enum AddCatStep: Int, CaseIterable {
    case basicInfo
    case details
    case review

    var title: String {
        switch self {
        case .basicInfo: return "Basic Info"
        case .details: return "Details"
        case .review: return "Review"
        }
    }

    var fields: [CatFormField] {
        switch self {
        case .basicInfo: return [.name, .breed]
        case .details: return [.age, .description]
        case .review: return []
        }
    }

    var previous: AddCatStep? { AddCatStep(rawValue: rawValue - 1) }
    var next: AddCatStep? { AddCatStep(rawValue: rawValue + 1) }
}
