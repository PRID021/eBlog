import SwiftUI

// Extend Color to include custom colors used throughout the app
extension Color {
    // Background and general colors
    static let background = Color(UIColor(red: 41/255, green: 43/255, blue: 47/255, alpha: 1.0))  // #292b2f - Very dark gray background
    static let onBackground = Color(UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1.0))  // #1c1c1c - Very dark gray for containers
    static let cardBackground = Color(UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0))  // #3a3a3a - Dark gray for cards
    static let primaryText = Color(UIColor.white)  // #ffffff - White for primary text
    static let secondaryText = Color(UIColor(red: 164/255, green: 164/255, blue: 164/255, alpha: 1.0))  // #a4a4a4 - Light gray for secondary text
    static let accentColor = Color(UIColor(red: 68/255, green: 183/255, blue: 255/255, alpha: 1.0))  // #44b7ff - Light blue for accent elements
    static let errorColor = Color(UIColor.systemRed)  // Red for errors or warnings
    
    // Shadows
    static let shadowColor = Color.black.opacity(0.3)  // Soft shadow for elements
}
