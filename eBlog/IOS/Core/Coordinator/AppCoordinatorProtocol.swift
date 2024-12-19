//
//  File.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation
import SwiftUI


protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    func setRoot(_ screen: Screen)
    func push(_ screen:  Screen)
    func pushReplace(_ screen: Screen)
    func presentSheet(_ sheet: Sheet)
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenOver()
}
