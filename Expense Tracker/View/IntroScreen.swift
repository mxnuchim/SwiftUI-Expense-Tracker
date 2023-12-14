//
//  IntroScreen.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

struct IntroScreen: View {
    // handle visibility status
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    var body: some View {
        VStack(spacing: 15, content: {
            Text("What's new in the \n Expense Tracker")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 65)
                .padding(.bottom, 35)
            
            VStack(alignment: .leading, spacing: 25, content: {
                PointView(symbol: "dollarsign", title: "Finances", subtitle: "Keep track of your income and expenses")
                
                PointView(symbol: "chart.bar.fill", title: "Charts", subtitle: "Visualize your transactions with real-time graphic representations")
                
                PointView(symbol: "magnifyingglass", title: "Advanced Filtering", subtitle: "Find specific expenses with our advanced search and filtering functionality")

            })
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.horizontal, 15)
            
            Spacer(minLength: 10)
            
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 14)
                    .background(appTint.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
                
            })
        })
        .padding(15)
    }
    
    // Points view
    @ViewBuilder
    func PointView(symbol: String, title: String, subtitle: String) -> some View{
        HStack(spacing: 20){
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 45)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .foregroundStyle(.gray)
            })
        }
    }
}

#Preview {
    IntroScreen()
}
