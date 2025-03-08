import SwiftUI

struct FontManager {
    enum FontWeight: String {
        case regular = "FiraCode-Regular"
        case bold = "FiraCode-Bold"
        case medium = "FiraCode-Medium"
        case semiBold = "FiraCode-SemiBold"
        case light = "FiraCode-Light"
        // Add other weights as needed
    }

    static func customFont(_ weight: FontWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}
