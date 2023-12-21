//
//  NewEntryView.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 17/12/2023.
//

import SwiftUI
import WidgetKit

struct TransactionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category:Category = .expense
    
    @State var tint: TintColor = tints.randomElement()!
    
    var transactionToEdit: Transaction?
    
    var body: some View {
        ScrollView(.vertical){
            VStack(spacing: 15){
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title, remarks: remarks.isEmpty ? "Remarks" : remarks, 
                    amount: amount,
                    dateAdded: dateAdded,
                    category: category,
                    tintColor: tint
                ))
                
                CustomSection("Title", "Airpods Max", value: $title)
                
                CustomSection("Remarks", "Apple Airpods Max - Sky blue", value: $remarks)
                
                // Amount & category checkbox
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    HStack(spacing: 15){
                        HStack(spacing: 4){
                            Text(currencySymbol)
                                .font(.callout.bold())
                            
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                        .frame(maxWidth: 130)
                           
                        
                        // Checkbox
                        CategoryCheckbox()
                    }
                })
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date] )
                        .datePickerStyle(.graphical)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                })
            }
            .padding(15)
        }
        .navigationTitle("\(transactionToEdit == nil ? "Add" : "Edit") Transaction")
        .background(.gray.opacity(0.15))
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing){
                Button("Save", action: save)
            }
        })
        .onAppear(perform: {
            if let transactionToEdit {
                // Load all existing ata if a transaction to edit exists
                title = transactionToEdit.title
                remarks = transactionToEdit.remarks
                dateAdded = transactionToEdit.dateAdded
                if let category = transactionToEdit.rawCategory {
                    self.category = category
                }
                amount = transactionToEdit.amount
                if let tint = transactionToEdit.tint {
                    self.tint = tint
                }
                
            }
        })
    }
    
    func save() {
        // Saving new entry with SwiftData
        
        if transactionToEdit != nil {
            transactionToEdit?.title = title
            transactionToEdit?.remarks = remarks
            transactionToEdit?.amount = amount
            transactionToEdit?.category = category.rawValue
            transactionToEdit?.dateAdded = dateAdded
        } else {
            let transaction = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            
            context.insert(transaction)
        }
        
        
        dismiss()
        // Updating widget
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @ViewBuilder
    func CustomSection(_ title: String, _ placeholder: String, value:Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            
            TextField(placeholder, text: value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
                .keyboardType(.decimalPad)
        })
    }
    
    // checkbox component
    @ViewBuilder
    func CategoryCheckbox() -> some View {
        HStack(spacing: 10){
            ForEach(Category.allCases, id: \.rawValue){ category in
                HStack(spacing: 5){
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        
                        if self.category == category {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                                .foregroundStyle(appTint)
                        }
                    }
                    
                    Text(category.rawValue)
                        .font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .hSpacing()
        .background(.background, in: .rect(cornerRadius: 10))
        
    }
    
    // Number formatter
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle  = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
}

#Preview {
    NavigationStack {
        TransactionView()
    }
}
