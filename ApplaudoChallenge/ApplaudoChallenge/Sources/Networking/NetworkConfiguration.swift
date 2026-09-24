//
//  NetworkConfiguration.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import NetworkLayer

enum NetworkConfiguration {
    /// Use `.mock()` to run against local sample data without network access.
    static let environment: NetworkEnvironment = .live
}
