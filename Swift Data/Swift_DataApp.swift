//
//  Swift_DataApp.swift
//  Swift Data
//
//  Created by Nizami Tagiyev on 18.06.2024.
//

import SwiftUI
import SwiftData

@main
struct Swift_DataApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([Expense.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
