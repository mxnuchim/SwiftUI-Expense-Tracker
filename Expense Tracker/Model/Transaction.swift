//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

struct Transaction: Identifiable {
    let id: UUID = .init()
    var title: String
    var remarks: String
    var amount: Double
    var dateAdded: Date
    var  category: String
    var tintColor: String
    
    init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
        self.title = title
        self.remarks = remarks
        self.amount = amount
        self.dateAdded = dateAdded
        self.category = category.rawValue
        self.tintColor = tintColor.color
    }
    
    // Extract color value from tint color
    var color: Color {
        return tints.first(where: {$0.color == tintColor})?.value ?? appTint
    }
}

var sampleTransactions: [Transaction] = [
    .init(title: "Magic Keyboard", remarks: "Apple Magic Keyboard", amount: 88700, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Apple Music", remarks: "Apple Music Subscription", amount: 900, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Netflix", remarks: "Netflix Subscription", amount: 3400, dateAdded: .now, category: .expense, tintColor: tints.randomElement()!),
    .init(title: "Payment", remarks: "Weekly Salary Received", amount: 365000, dateAdded: .now, category: .income, tintColor: tints.randomElement()!),
]

