//
//  Task.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation

struct Task: Identifiable, Codable,Equatable,Hashable {
    let id: UUID          // Unique identifier for the task
    var title: String     // Name or title of the task
    var description: String // Description of the task
    var priority: Priority // Task priority (e.g., High, Medium, Low)
    var dueDate: Date?    // Optional due date for the task
    var isCompleted: Bool // Tracks if the task is completed

    // Initializer
    init(title: String, description: String, priority: Priority, dueDate: Date? = nil, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.priority = priority
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}

// Enum to represent task priority
enum Priority: String, Codable, Equatable, Hashable{
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}
