//
//  CustomSlider.swift
//  eBlog
//
//  Created by mac on 4/11/25.
//

import SwiftUI
struct CustomSlider: View {
    @Binding var progress: Double
    let range: ClosedRange<Double>
    let onEditingChanged: (Bool) -> Void = { _ in }

    private var safeRange: ClosedRange<Double> {
        let lower = range.lowerBound
        let upper = max(range.lowerBound, range.upperBound)
        return lower...upper
    }

    private var normalizedProgress: Binding<Double> {
        let lower = safeRange.lowerBound
        let upper = safeRange.upperBound
        let length = upper - lower

        return Binding(
            get: {
                length > 0 ? (progress - lower) / length : 0
            },
            set: { newValue in
                progress = lower + newValue * length
            }
        )
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbSize: CGFloat = 16
            let thumbOffset = width * CGFloat(normalizedProgress.wrappedValue) - thumbSize / 2

            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6)

                // Progress fill
                Capsule()
                    .fill(Color.blue)
                    .frame(width: max(width * CGFloat(normalizedProgress.wrappedValue), 0), height: 6)

                // Thumb
                Circle()
                    .fill(Color.white)
                    .shadow(radius: 3)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: thumbOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = min(max(value.location.x / width, 0), 1)
                                normalizedProgress.wrappedValue = newValue
                                onEditingChanged(true)
                            }
                            .onEnded { _ in
                                onEditingChanged(false)
                            }
                    )
            }
        }
        .frame(height: 44)
        .onChange(of: range) { _ in
            // Clamp progress if needed
            progress = progress.clamped(to: safeRange)
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
