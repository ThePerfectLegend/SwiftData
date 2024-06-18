//
//  Expense.swift
//  Swift Data
//
//  Created by Nizami Tagiyev on 18.06.2024.
//

import Foundation
import SwiftData

@Model
class Expense {
    var name: String
    var date: Date
    var value: Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
