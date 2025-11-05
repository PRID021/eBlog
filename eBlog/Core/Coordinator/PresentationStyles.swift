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
    case featuringDetail(featuring: Featuring)
    
    /// Musing Player
    case player(track: Track)
    case library

    var id: Self { return self }
}

enum Sheet: Identifiable, Hashable {
    case detailTask(named: Task)
    
    var id: Self { return self }
}

enum FullScreenCover: Identifiable, Hashable {
    case supplimentDetail
    var id: Self { return self }
}

extension FullScreenCover {

    func hash(into hasher: inout Hasher) {
        switch self {
        case .supplimentDetail:
            hasher.combine(self)
        }
    }
    
    // Conform to Equatable
    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (_,_ ):
            return true
        }
    }
}
