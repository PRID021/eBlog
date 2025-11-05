//
//  AnimatedLightningText.swift
//  eBlog
//
//  Created by mac on 4/11/25.
//

import SwiftUI

struct AnimatedLightningText: View {
    let text: String
    let fontSize: CGFloat
    let color: Color
    let durationPerCharacter: Double
    
    @State private var activeIndex = 0
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(Array(text.enumerated()),id: \.offset){ index, character in
                Text(String(character))
                    .font(.system(size: fontSize,weight: .bold))
                    .foregroundStyle(color)
                    .opacity(activeIndex == index ? 1.0 : 0.3)
                    .animation(.easeInOut(duration: 0.3), value: activeIndex)
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: durationPerCharacter, repeats: true) { timer in
            withAnimation {
                if activeIndex < text.count - 1 {
                    activeIndex += 1
                } else {
                    activeIndex = 0
                }
            }
        }
    }
}

#Preview {
    AnimatedLightningText(text: "eBlog", fontSize: 24, color: .blue, durationPerCharacter: 0.5)
}
