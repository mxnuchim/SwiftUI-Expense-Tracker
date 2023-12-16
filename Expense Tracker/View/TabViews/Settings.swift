//
//  Settings.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

struct Settings: View {
    
    // user properties
    @AppStorage("username") private var username: String = ""
    
    // App lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    var body: some View {
        NavigationStack{
            List{
                Section("username"){
                    TextField("Your Username", text: $username)
                }
                
                Section("App Lock"){
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock When App Is In The Background", isOn: $lockWhenAppGoesBackground)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        
    }
}

#Preview {
    ContentView()
}
