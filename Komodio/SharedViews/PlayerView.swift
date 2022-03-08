//
//  PlayerView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI
import Combine
import AVKit

/// A View with the player
struct PlayerView: View {
    /// The Video item we want to play
    @Binding var video: MediaItem
    /// The presentation mode
    /// - Note: Need this to go back a View on iOS after the video has finnished
    @Environment(\.presentationMode) var presentationMode
    /// The View
    var body: some View {
        Wrapper(video: video) {
            /// # Actions after a video has finnished
            /// Mark the video as played
            video.markAsPlayed()
            /// Go back a View on tvOS or iOS; macOS ignores this
            presentationMode.wrappedValue.dismiss()
#if os(macOS)
            /// Close the Player Window on macOS
            NSApplication.shared.keyWindow?.close()
#endif
        }
    }
}

extension PlayerView {
    
    /// A wrapper View around the ``VideoPlayer`` so we can observe it
    /// and act after a video has finnised playing
    struct Wrapper: View {
        /// Observe the player
        @StateObject private var playerModel: PlayerModel
        /// Init the Wrapper View
        init(video: MediaItem, endAction: @escaping () -> Void) {
            _playerModel = StateObject(wrappedValue: PlayerModel(video: video, endAction: endAction))
        }
        /// The View
        var body: some View {
            VideoPlayer(player: playerModel.player)
                .task {
                    /// Check if we are already playing or not
                    if playerModel.player.isPlaying == false {
                        playerModel.player.play()
                    }
                }
                .ignoresSafeArea(.all)
        }
        /// The PlayerModel class
        class PlayerModel: ObservableObject {
            /// The AVplayer
            let player: AVPlayer
            /// Init the PlayerModel class
            init(video: MediaItem, endAction: @escaping () -> Void) {
                /// Setup the player
                let playerItem = AVPlayerItem(url: URL(string: video.file)!)
#if os(tvOS)
                /// tvOS can add aditional info to the player
                playerItem.externalMetadata = createMetadataItems(video: video)
#endif
                /// Create a new Player
                player = AVPlayer(playerItem: playerItem)
                player.actionAtItemEnd = .none
                /// Get notifications
                NotificationCenter
                    .default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                         object: nil,
                                         queue: nil) { _ in endAction() }
            }
        }
    }
    
    /// Create a link to the PlayerView
    /// - On macOS, the player will open in a new Window
    /// - On tvOS and iOS it is just another NavigationLink for the stack
    struct Link<Label: View, Destination: View>: View {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The Kodi item we want to play
        private var item: MediaItem
        /// The label for the link; it is a View
        private var label: Label
        /// Thej View destinatiomn for the link
        private var destination: Destination
        /// Create a `label` and `destination`
        init(item: MediaItem, destination: Destination, @ViewBuilder label: () -> Label) {
            self.item = item
            self.label = label()
            self.destination = destination
        }
        /// The View
        var body: some View {
#if os(macOS)
            Button(action: {
                destination
                    .environmentObject(kodi)
                    .openInWindow(title: item.title, size: NSSize(width: 640, height: 360))
            }, label: {
                label
            })
                .keyboardShortcut(.defaultAction)
#else
            NavigationLink(destination: destination.onAppear { router.push(Route.player) }) {
                label
            }
            .padding()
#endif
        }
    }
}
