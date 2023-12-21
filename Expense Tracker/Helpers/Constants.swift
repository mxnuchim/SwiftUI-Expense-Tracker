//
//  Constants.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

let appTint: Color = .blue

let oliveGreen = Color(red: 0.35, green: 0.45, blue: 0.12)

func formatNumber(_ value: Double) -> String {
    let absValue = abs(value)
    let suffix: String
    var formattedValue: Double
    
    if absValue >= 1_000_000_000 {
        formattedValue = value / 1_000_000_000
        suffix = "B"
    } else if absValue >= 1_000_000 {
        formattedValue = value / 1_000_000
        suffix = "M"
    } else if absValue >= 1_000 {
        formattedValue = value / 1_000
        suffix = "K"
    } else {
        return "\(Int(value))"
    }
    
    return String(format: formattedValue.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f%@" : "%.2f%@", formattedValue, suffix)
}

