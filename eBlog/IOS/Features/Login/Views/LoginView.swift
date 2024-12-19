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
            LoginViewContent(appCoordinator: appCoordinator)

        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                HStack(spacing: 5) {
                    ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                        Text(String(character))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(activeIndex == index ? 1.0 : 0.3)
                            .animation(.easeInOut(duration: 0.3), value: activeIndex)
                    }
                }
                .onAppear {
                    animateLightningEffect()
                }
            }
        }
    }

    /// Lightning animation logic
    private func animateLightningEffect() {
        let durationPerCharacter = 0.3
        let totalDuration = Double(text.count) * durationPerCharacter

        Timer.scheduledTimer(withTimeInterval: durationPerCharacter, repeats: true) { timer in
            if activeIndex < text.count - 1 {
                activeIndex += 1
            } else {
                activeIndex = 0 // Restart animation
            }
        }

        // Transition to the main view after the lightning animation
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration * 2) {
            isActive = true
        }
    }
}

#Preview {
    LoginView()
}
