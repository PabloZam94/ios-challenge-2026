//
//  AppDependencies.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import NetworkLayer

struct AppDependencies {
    let breedService: CatBreedServiceType
    let catStore: CatStoreType

    static let live = AppDependencies(
        breedService: CatBreedService(environment: NetworkConfiguration.environment),
        catStore: FileCatStore()
    )
}
