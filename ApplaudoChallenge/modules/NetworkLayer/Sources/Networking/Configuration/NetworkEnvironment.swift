//
//  NetworkEnvironment.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
import Moya

// MARK: - Network Environment
public enum NetworkEnvironment: Sendable {
    /// Performs real requests against The Cat API.
    case live
    /// Returns each target's `requestSampleData` through a stubbed Moya provider.
    case mock(delay: TimeInterval = 0.6)
}

extension NetworkEnvironment {
    func makeRequester() -> NetworkingRequesterType {
        switch self {
        case .live:
            return NetworkingRequester(provider: MoyaProvider<MultiTarget>.networkingProvider())
        case .mock(let delay):
            return NetworkingRequester(provider: MoyaProvider<MultiTarget>.stubbedProvider(delay: delay))
        }
    }
}
