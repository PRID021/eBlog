//
//  AppCoordinatorImpl.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation
import SwiftUI

class AppCoordinatorImpl: AppCoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()
    @Published var root: Screen = .login;
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    // MARK: - Navigation Functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func pushReplace(_ screen: Screen){
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(screen)
        
    }
    
    func setRoot(_ screen: Screen){
        self.root = screen;
        self.path = NavigationPath();
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenOver() {
        self.fullScreenCover = nil
    }
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .home:
            MainView()
        case .login:
            LoginView()
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .detailTask(named: let task):
            Text(task.description)
            
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .addHabit(onSaveButtonTap: _):
            Text("Add habbit")
        }
    }
}
