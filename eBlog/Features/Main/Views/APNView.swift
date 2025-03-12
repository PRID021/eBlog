// APNView.swift
import SwiftUI

struct APNView: View {
    @EnvironmentObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("Future Tab")
                .font(.headline)
            
            if viewModel.isPermissionGranted {
                Button("Schedule Notification") {
                    viewModel.scheduleNotification()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            } else {
                Text("Notifications not available")
                    .foregroundColor(.red)
                
                Button("Request Permission") {
                    viewModel.requestPermissionIfNeeded()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cardBackground)
    }
}

#Preview {
    APNView()
        .environmentObject(MainViewModel())
}
