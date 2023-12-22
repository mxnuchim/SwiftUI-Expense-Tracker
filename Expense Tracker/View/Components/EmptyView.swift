//
//  EmptyView.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 22/12/2023.
//

import SwiftUI

struct EmptyView: View {
    var message: String
    var symbol: String
    var body: some View {
        VStack (spacing: 20) {
            Image(systemName: symbol)
                .font(.title)
                .foregroundStyle(appTint)
            
            Text(message)
                .foregroundStyle(.primary)
                .font(.callout.bold())
        }
        .padding(.top, 15)
    }
}
