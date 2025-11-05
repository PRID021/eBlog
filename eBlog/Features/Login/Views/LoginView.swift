//
//  SplashScreenView.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @State private var isActive = false
    @State private var activeIndex = 0 // Tracks the active character index
    let text = "eBlog" // The text to animate

    var body: some View {
        if isActive {
            LoginViewContent()
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                AnimatedLightningText(
                    text: text,
                    fontSize: 48,
                    color: .white,
                    durationPerCharacter: 0.3
                )
                .onAppear {
                    let durationPerCharacter = 0.3
                    let totalDuration = Double(text.count) * durationPerCharacter
                    DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration * 2) {
                        isActive = true
                    }
                }
            }
        }
    }
}
