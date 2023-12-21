//
//  TintColor.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

struct TintColor: Identifiable {
    let id: UUID = .init()
    var color: String
    var value: Color
}

var tints: [TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Blue", value: .blue),
    .init(color: "Green", value: oliveGreen),
    .init(color: "Teal", value: .teal),
    .init(color: "Black", value: .black),
    .init(color: "Orange", value: .orange),
]
