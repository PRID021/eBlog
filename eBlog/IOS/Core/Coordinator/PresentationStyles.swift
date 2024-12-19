//
//  PresentationStyles.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation

enum Screen: Identifiable, Hashable {
    case home
    case login
    
    var id: Self { return self }
}

enum Sheet: Identifiable, Hashable {
    case detailTask(named: Task)
    
    var id: Self { return self }
}

enum FullScreenCover: Identifiable, Hashable {
    case addHabit(onSaveButtonTap: ((Habit) -> Void))

    var id: Self { return self }
}

extension FullScreenCover {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .addHabit:
            hasher.combine("addHabit")
        }
    }
    
    // Conform to Equatable
    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (.addHabit, .addHabit):
            return true
        }
    }
}
