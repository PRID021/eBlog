import SwiftUI

// Extend View to create modifiers for custom colors
extension View {
    // Background modifier
    func backgroundModifier() -> some View {
        self
            .background(Color.background)
            .cornerRadius(10)
    }

    // Card background modifier
    func cardBackgroundModifier() -> some View {
        self
            .background(Color.cardBackground)
            .cornerRadius(10)
    }

    // Apply primary text color
    func primaryTextModifier() -> some View {
        self
            .foregroundColor(Color.primaryText)
            .font(.body)
    }

    // Apply secondary text color
    func secondaryTextModifier() -> some View {
        self
            .foregroundColor(Color.secondaryText)
            .font(.body)
    }

    // Apply accent color (for highlights, buttons, etc.)
    func accentColorModifier() -> some View {
        self
            .foregroundColor(Color.accentColor)
    }

    // Apply error text color
    func errorTextModifier() -> some View {
        self
            .foregroundColor(Color.errorColor)
            .font(.caption)
    }

    // Apply shadow to the view
    func shadowModifier() -> some View {
        self
            .shadow(color: Color.shadowColor, radius: 5, x: 0, y: 2)
    }

    // On background color for container areas
    func onBackgroundModifier() -> some View {
        self
            .background(Color.onBackground)
            .cornerRadius(10)
    }
}
