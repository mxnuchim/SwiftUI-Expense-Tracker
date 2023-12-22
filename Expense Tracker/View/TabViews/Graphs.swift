//
//  Graphs.swift
//  Expense Tracker
//
//  Created by Manuchim Oliver on 14/12/2023.
//

import SwiftUI
import Charts
import SwiftData

struct Graphs: View {
    
    // View properties
    @Query(animation: .snappy) private var transactions: [Transaction]
    @State private var chartGroups: [ChartGroup] = []
    var body: some View {
        NavigationStack {
            ScrollView(.vertical){
                LazyVStack(spacing: 10){
                    // Chart View
                    if chartGroups.isEmpty {
                        EmptyView(message: "No transactions found", symbol: "exclamationmark.magnifyingglass")
                    } else {
                        ChartView()
                            .frame(height: 200)
                            .padding(10)
                            .padding(.top, 10)
                            .background(.background, in: .rect(cornerRadius: 10))
                    }
                    
                    ForEach(chartGroups) { group in
                        VStack(alignment: .leading, spacing: 10){
                            Text(format(date: group.date, format: "MMMM yy"))
                                .font(.callout.bold())
                                .foregroundStyle(.black)
                                .hSpacing(.leading)
                            
                            NavigationLink {
                                ListOfExpenses(month: group.date)
                            } label: {
                                    CardView(income: group.totalIncome, expense: group.totalExpense)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("Charts")
            .background(.gray.opacity(0.15))
            .onAppear{
                // create chart group
                createChartGroup()
            }
        }
    }
    
    @ViewBuilder
    func ChartView() -> some View  {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                        BarMark(
                            x: .value("Month", format(date: group.date, format: "MMM yy")),
                            y: .value(chart.category.rawValue, chart.totalValue), width: 20
                        )
                        .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                        .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis{
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(formatNumber(doubleValue))
                }
            }
        }
        .chartForegroundStyleScale(range: [Color.teal.gradient, Color.red.gradient])
    }
    
    func createChartGroup() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            
            let groupedByDate = Dictionary(grouping: transactions) { transaction in
                let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
                
                return components
            }
            
            // Sort groups by Date
            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == Category.income.rawValue })
                let expense = dict.value.filter({ $0.category == Category.expense.rawValue })
                
                let totalIncomeValue = total(income, category: .income)
                let totalExpenseValue = total(expense, category: .expense)
                
                return .init(
                    date: date,
                    categories: [
                        .init(totalValue: totalIncomeValue, category: .income),
                        .init(totalValue: totalExpenseValue, category: .expense)
                    ],
                    totalIncome: totalIncomeValue,
                    totalExpense: totalExpenseValue
                )
            }
            
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }
    
    // List transactions for the selected month
    struct ListOfExpenses: View {
        let month: Date
        var body: some View {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    Section {
                        FilterTransactionView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .income) { transactions in
                            ForEach(transactions) { transaction in
                                NavigationLink  {
                                    TransactionView(transactionToEdit: transaction)
                                } label: {
                                    TransactionCardView(transaction: transaction)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } header: {
                        Text("Income")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                    
                    Section {
                        FilterTransactionView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .expense) { transactions in
                            ForEach(transactions) { transaction in
                                NavigationLink  {
                                    TransactionView(transactionToEdit: transaction)
                                } label: {
                                    TransactionCardView(transaction: transaction)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    } header: {
                        Text("Expenses")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                }
                .padding(15)
            }
            .background(.gray.opacity(0.15))
            .navigationTitle(format(date: month, format: "MMMM yy"))
        }
    }
}

#Preview {
    Graphs()
}
