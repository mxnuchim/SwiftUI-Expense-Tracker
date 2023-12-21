//
//  CardView.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(appTint.gradient)
                .overlay(alignment: .leading){
                    Circle()
                        .fill(appTint.opacity(0.5).gradient)
                        .overlay {
                            Circle()
                                .fill(.white.opacity(0.13).gradient)
                        }
                        .scaleEffect(2, anchor: .topLeading)
                        .offset(x: -50, y: -100)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
            VStack(spacing: 0) {
                HStack(spacing: 12){
                    Text("\(currencyString(income - expense))")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    
                    Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                        .font(.title3)
                        .foregroundStyle(expense > income ? .red : .green)
                }
                .padding(.bottom, 25)
                
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.rawValue){ category in
                        let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                        let tint = category == .income ? Color.green : Color.red
                        HStack(spacing: 10){
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(tint)
                                .frame(width: 35, height: 35)
                                .background{
                                    Circle()
                                        .fill(tint.opacity(0.25).gradient)
                                }
                            VStack(alignment: .leading, spacing: 4){
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                                
                                Text(currencyString(category == .income ? income : expense, allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                            
                            if category == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 25)
            .padding(.top, 15)
        }
    }
}

#Preview {
    ScrollView {
        CardView(income: 4700000, expense: 1350000)
    }
}
