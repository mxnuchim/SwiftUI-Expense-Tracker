//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

struct ContentView: View {
    // Intro Screen visibility status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    // Active tab
    @State private var activeTab: Tab = .recents
    var body: some View {
        TabView(selection: $activeTab) {
            Text("Recents")
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            Text("Search")
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            Text("Charts")
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            Text("Settings")
                .tag(Tab.settings)
                .tabItem { Tab.settings.tabContent }
        }
        .tint(appTint)
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreen()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}
