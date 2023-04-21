//
//  MyReactor.swift
//  ExDiffable
//
//  Created by 김종권 on 2023/04/21.
//

import RxCocoa
import RxSwift
import ReactorKit

final class MyReactor: Reactor {
    // MARK: Types
    enum Action {
        case load
        case append
        case remove
        case removeCenter
    }
    enum Mutation {
        case setItems([MyItem])
        case appendItem
        case removeItem
        case removeCenter
    }
    struct State {
        var items: [MyItem] = []
    }
    
    // MARK: Properties
    let initialState: State
    
    // MARK: Initializers
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return .just(.setItems([.init(value: 0), .init(value: 1), .init(value: 2), .init(value: 3), .init(value: 4)]))
        case .append:
            return .just(.appendItem)
        case .remove:
            return .just(.removeItem)
        case .removeCenter:
            return .just(.removeCenter)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setItems(array):
            state.items = array
        case .appendItem:
            state.items.append(.init(value: state.items.count))
        case .removeItem:
            guard !state.items.isEmpty else { break }
            state.items.removeLast()
        case .removeCenter:
            guard !state.items.isEmpty else { break }
            let centerIndex = (state.items.count - 1) / 2
            state.items.remove(at: centerIndex)
        }
        return state
    }
}

