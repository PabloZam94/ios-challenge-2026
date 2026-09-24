//
//  LoadingState.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

enum LoadingState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(message: String)
}
