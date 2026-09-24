//
//  ApplaudoChallengeTests.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Foundation
import NetworkLayer
import Testing
@testable import ApplaudoChallenge

struct NetworkErrorUserMessageTests {

    @Test func mapsEachErrorToAFriendlyMessage() {
        let server = NetworkError.serverError(statusCode: 500, data: Data())
        let decoding = NetworkError.decodingFailed(underlying: URLError(.cannotParseResponse))
        let unknown = NetworkError.unknown(underlying: URLError(.notConnectedToInternet))

        let messages = [server, decoding, unknown].map(\.userMessage)

        #expect(Set(messages).count == 3)
        #expect(messages.allSatisfy { !$0.isEmpty })
    }
}
