//
//  CoordinatorView.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//


import SwiftUI


import SwiftUI

struct CoordinatorView: View {
    @StateObject var appCoordinator: AppCoordinatorImpl = AppCoordinatorImpl()
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build(appCoordinator.root)
                .navigationDestination(for: Screen.self) { screen in
                    appCoordinator.build(screen)
                }
                .sheet(item: $appCoordinator.sheet) { sheet in
                    appCoordinator.build(sheet)
                }
                .fullScreenCover(item: $appCoordinator.fullScreenCover) { fullScreenCover in
                    appCoordinator.build(fullScreenCover)
                }
        }
        .environmentObject(appCoordinator)
    }
}

