//
//  ContentView.swift
//  Swift Data
//
//  Created by Nizami Tagiyev on 18.06.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var showItemSheet = false
    @Query(filter: #Predicate<Expense> { $0.value > 100 }, sort: \Expense.date)
    var expenses: [Expense]
    @Environment(\.modelContext) private var context
    @State private var expenseToEdit: Expense?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                   ExpenseRow(expense: expense)
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                }
                .onDelete{ indexSet in
                    for index in indexSet {
                        context.delete(expenses[index])
                    }
                }
                
            }
            .navigationTitle("Expenses")
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        showItemSheet = true
                    }
                }
            }
            .sheet(isPresented: $showItemSheet, content: {
                AddExpenseSheet()
            })
            .sheet(item: $expenseToEdit, content: { expense in
                UpdateExpenseSheet(expence: expense)
            })
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start Adding expenses to see you list")
                    }, actions: {
                        Button("Add expense") {
                            showItemSheet = true
                        }
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ExpenseRow: View {
    
    let expense: Expense
    
    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 60, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "USD"))
        }
    }
}

struct AddExpenseSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name:", text: $name)
                DatePicker("Date:", selection: $date, displayedComponents: .date)
                TextField("Value:", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, value: value)
                        context.insert(expense)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateExpenseSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var expence: Expense
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name:", text: $expence.name)
                DatePicker("Date:", selection: $expence.date, displayedComponents: .date)
                TextField("Value:", value: $expence.value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        
                        dismiss()
                    }
                }
            }
        }
    }
}
