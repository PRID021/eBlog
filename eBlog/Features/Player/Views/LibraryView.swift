//
//  LibraryView.swift
//  eBlog
//
//  Created by mac on 4/11/25.
//

import Foundation
import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel = LibraryViewModel()
    @State private var showImporter = false
    @State private var selectedTrack: Track?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tracks) { track in
                    NavigationLink(destination: TrackDetailView(track: track, library: viewModel)) {
                        Text(track.name)
                    }
                }
                .onDelete(perform: deleteTrack) // <-- enable swipe to delete
            }
            .navigationTitle("My Tracks")
            .toolbar {
                Button(action: {
                    let name = "Track \(viewModel.tracks.count + 1)"
                    viewModel.createTrack(named: name)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear { viewModel.loadLibrary() }
    }

    // MARK: - Delete function
    private func deleteTrack(at offsets: IndexSet) {
        offsets.forEach { index in
            let track = viewModel.tracks[index]
            viewModel.delete(track:track) // <-- implement this in your ViewModel
        }
    }
}
