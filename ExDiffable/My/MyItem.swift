//
//  MyItem.swift
//  ExDiffable
//
//  Created by 김종권 on 2023/04/21.
//

import Foundation

struct MyItem: Hashable {
    let id = UUID()
    let value: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
