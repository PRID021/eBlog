//
//  eBlogApp.swift
//  eBlog
//
//  Created by mac on 18/12/24.
//

import SwiftUI

@main
struct eBlogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}


#Preview {
    CoordinatorView()
}
