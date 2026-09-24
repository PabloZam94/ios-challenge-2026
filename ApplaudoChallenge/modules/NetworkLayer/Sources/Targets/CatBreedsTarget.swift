//
//  CatBreedsTarget.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
import Moya

// MARK: - Cat Breeds Target
enum CatBreedsTarget {
    case getBreeds(page: Int, limit: Int)
}

// MARK: - NetworkingTargetType Conformance
extension CatBreedsTarget: NetworkingTargetType {
    var requestPath: String {
        switch self {
        case .getBreeds:
            return "breeds"
        }
    }

    var requestMethod: RequestMethod {
        switch self {
        case .getBreeds:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .getBreeds(page, limit):
            return .requestParameters(
                parameters: parametersAsDictionary(PaginationParameters(page: page, limit: limit)),
                encoding: URLEncoding.queryString
            )
        }
    }

    /// Served by the mock environment until the real endpoint is available.
    var requestSampleData: Data {
        switch self {
        case let .getBreeds(page, limit):
            return CatBreedMocks.pageData(page: page, limit: limit)
        }
    }
}
