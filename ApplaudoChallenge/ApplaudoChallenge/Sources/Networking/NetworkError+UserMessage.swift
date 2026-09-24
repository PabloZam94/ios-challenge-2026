//
//  NetworkError+UserMessage.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import NetworkLayer

extension NetworkError {
    var userMessage: String {
        switch self {
        case .serverError:
            return "The server is having trouble right now. Please try again later."
        case .decodingFailed:
            return "We received unexpected data. Please try again later."
        case .unknown:
            return "Check your internet connection and try again."
        }
    }
}
