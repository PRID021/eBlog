//
//  ToastView.swift
//  eBlog
//
//  Created by mac on 6/2/25.
//
import Foundation
import SwiftUI

struct Toast: ViewModifier {
    
    static let short: TimeInterval = 2
    static let long: TimeInterval = 3.5

    let message: String
    @Binding var isShowing: Bool
    let config: Config
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                toastView
                    .transition(config.transition)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration) {
                            withAnimation(config.animation) {
                                isShowing = false
                            }
                        }
                    }
            }
        }
    }
    
    private var toastView: some View {
        VStack {
            Spacer()
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(config.textColor)
                .font(config.font)
                .padding(.vertical, 16)
                .padding(.horizontal, 30)
                .background(Capsule().foregroundColor(config.backgroundColor))
                .onTapGesture {
                    withAnimation(config.animation) {
                        isShowing = false
                    }
                }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
    }
    
    struct Config {
        let textColor: Color
        let font: Font
        let backgroundColor: Color
        let duration: TimeInterval
        let transition: AnyTransition
        let animation: Animation

        init(textColor: Color = .white,
             font: Font = .system(size: 14),
             backgroundColor: Color = .black.opacity(0.7),
             duration: TimeInterval = Toast.short,
             transition: AnyTransition = .opacity,
             animation: Animation = .easeInOut(duration: 0.3)) {
            
            self.textColor = textColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.duration = duration
            self.transition = transition
            self.animation = animation
        }
    }
}
