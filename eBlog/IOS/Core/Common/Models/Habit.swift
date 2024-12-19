//
//  Habit.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable,Hashable {
    let id: UUID          // Unique identifier for each habit
    var title: String     // Name or title of the habit
    var description: String // Description of the habit
    var frequency: Int    // Frequency of the habit (e.g., number of days per week)
    var isCompleted: Bool // Tracks if the habit is completed for the day

    // Initializer
    init(title: String, description: String, frequency: Int, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.frequency = frequency
        self.isCompleted = isCompleted
    }
}
