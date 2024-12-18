//
//  ContentView.swift
//  eBlog
//
//  Created by mac on 18/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(FontManager.customFont(.regular, size: 18))
            Text("Bold Text Example")
                .font(FontManager.customFont(.bold, size: 18))
            Text("Medium Text Example")
                .font(FontManager.customFont(.medium, size: 18))
            Text("SemiBold Text Example")
                .font(FontManager.customFont(.semiBold, size: 18))
            Text("Light Text Example")
                .font(FontManager.customFont(.light, size: 18))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
