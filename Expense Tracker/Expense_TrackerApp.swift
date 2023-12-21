//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI
import WidgetKit

@main
struct Expense_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear{
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        .modelContainer(for:[Transaction.self])
    }
}
