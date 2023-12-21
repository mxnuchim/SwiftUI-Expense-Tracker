//
//  ExpensesView.swift
//  ExpensesView
//
//  Created by Manuchim Oliver on 21/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []

        entries.append(.init(date: .now))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
}

struct ExpensesViewEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            FilterTransactionView(startDate: .now.startOfMonth, endDate: .now.endOfMonth) { transactions in
                CardView(
                    income: total(transactions, category: .income), 
                    expense: total(transactions, category: .expense)
                )
            }
        }
        .background(appTint.gradient)
    }
}

struct ExpensesView: Widget {
    let kind: String = "ExpensesView"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ExpensesViewEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Transaction.self)
        }
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
        .configurationDisplayName("Expense Tracker Widget")
        .description("Tap me to view your expenditure in real time.")
    }
}

#Preview(as: .systemSmall) {
    ExpensesView()
} timeline: {
    WidgetEntry(date: .now)
}
