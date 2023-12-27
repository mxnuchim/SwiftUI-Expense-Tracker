//
//  Tab.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

enum Tab: String {
    case recents = "Home"
    case search = "Search"
    case charts = "Charts"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
            case .recents:
                Image(systemName: "house")
                Text(self.rawValue)
            case .search:
                Image(systemName: "magnifyingglass")
                Text(self.rawValue)
            case .charts:
                Image(systemName: "chart.bar.xaxis")
                Text(self.rawValue)
            case .settings:
                Image(systemName: "gearshape")
                Text(self.rawValue)
        }
    }
}
