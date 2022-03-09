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
    /// The  items we want to play
    let items: [MediaItem]
    /// The presentation mode
    /// - Note: Need this to go back a View on iOS after the video has finnished
    @Environment(\.presentationMode) var presentationMode
    /// The View
    var body: some View {
        Wrapper(items: items) {
            /// # Actions after a video has finished
            logger("END OF PLAYLIST")
            /// Mark the item as played
            //items.markAsPlayed()
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
        init(items: [MediaItem], endAction: @escaping () -> Void) {
            _playerModel = StateObject(wrappedValue: PlayerModel(items: items, endAction: endAction))
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
                .onDisappear {
                    playerModel.player.removeAllItems()
                }
                .ignoresSafeArea(.all)
            #if os(tvOS)
                .onPlayPauseCommand {
                    logger("PLAY/PAUSE")
                    playerModel.player.isPlaying ? playerModel.player.pause() : playerModel.player.play()
                }
            #endif
//                .onMoveCommand(perform: { direction in
//                    if direction == .right {
//                        playerModel.player.advanceToNextItem()
//                    }
//                })
        }
        /// The PlayerModel class
        class PlayerModel: ObservableObject {
            /// The AVplayer
            let player: AVQueuePlayer
            /// Init the PlayerModel class
            init(items: [MediaItem], endAction: @escaping () -> Void) {
                /// Setup the player
            var playerItems: [AVPlayerItem] = []
                for item in items {
                let playerItem = AVPlayerItem(url: URL(string: item.file)!)
#if os(tvOS)
                /// tvOS can add aditional info to the player
                playerItem.externalMetadata = createMetadataItems(video: item)
#endif
                    playerItems.append(playerItem)
                }
                /// Create a new Player
                player = AVQueuePlayer(items: playerItems)
                //player = AVPlayer(playerItem: playerItem)
                player.actionAtItemEnd = .none
                /// Get notifications
                NotificationCenter
                    .default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                         object: nil,
                                         queue: nil) { [self] notification in
                        let currentItem = notification.object as? AVPlayerItem
                        
                        let file: String? = (currentItem?.asset as? AVURLAsset)?.url.absoluteString
                        
                        if var match = KodiConnector.shared.media.first(where: { $0.file == file }) {
                            match.markAsPlayed()
                        }
                        
                        if currentItem == playerItems.last {
                            endAction()
                        } else {
                            player.advanceToNextItem()
                        }
                        
                    }
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
