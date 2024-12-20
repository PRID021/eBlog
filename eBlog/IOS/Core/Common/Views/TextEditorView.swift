import SwiftUI

struct TextEditorView: View {
    
    @Binding var string: String
    @State private var textEditorHeight: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder text when editor is empty
            if string.isEmpty {
                Text("Placeholder recreated")
                    .foregroundColor(.gray)
                    .padding(.top, 12) // Align with the text
                    .padding(.leading, 18)
            }

            // TextEditor for dynamic content
            TextEditor(text: $string)
                .font(.system(size: 14))
                .frame(height: max(40, textEditorHeight)) // Minimum height of 40, but grows dynamically
                .padding(14)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
                .cornerRadius(10.0)
                .shadow(radius: 1.0)
        }
        .onPreferenceChange(ViewHeightKey.self) { value in
            // Dynamically adjust the height based on content size
            // Limit the maximum height to prevent infinite expansion
            let maxHeight: CGFloat = 150
            textEditorHeight = min(max(40, value), maxHeight)
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue() // Use the latest height from GeometryReader
    }
}

#Preview {
    TextEditorView(string: .constant("Your initial content here"))
}
