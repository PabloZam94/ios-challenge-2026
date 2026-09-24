//
//  Publisher+Scheduler.swift
//  ApplaudoChallenge
//
//  Created by Pablo Luis Velazquez Zamudio on 24/09/26.
//

import Combine

extension Publisher {
    /// Type-erased `receive(on:)` so view models can inject any scheduler (e.g. `ImmediateScheduler` in tests).
    func receive(onScheduler scheduler: any Scheduler) -> AnyPublisher<Output, Failure> {
        receiveOpened(on: scheduler)
    }

    private func receiveOpened<S: Scheduler>(on scheduler: S) -> AnyPublisher<Output, Failure> {
        receive(on: scheduler).eraseToAnyPublisher()
    }
}
