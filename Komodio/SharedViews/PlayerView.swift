//
//  PlayerView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

import SwiftlyKodiAPI
import Combine
import AVKit

/// A View with the player
struct PlayerView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The  items we want to play
    let items: [MediaItem]
    /// The View
    var body: some View {
        Wrapper(items: items) {
            /// # Actions after a playlist has finished
            logger("End of the playlist, close the View")
            router.pop()
        }
#if os(iOS)
        /// Close the player view with a drag gesture
        .gesture(
            DragGesture()
                .onEnded { _ in
                    logger("DRAG!!")
                    router.pop()
                }
        )
#endif
#if os(macOS)
        .onExitCommand {
            router.pop()
        }
#endif
    }
}

extension PlayerView {
    struct Overlay: View {
        let item: MediaItem?
        var body: some View {
            /// Show art when we are playing audio
            if let item = item, item.media == .song {
                ArtView.Poster(item: item)
                    .cornerRadius(9)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .macOS { $0.padding(.all, 60) }
                    .background(.black)
            } else {
                /// Force macOS to use all space in the window
                Color.clear
            }
        }
    }
}

extension PlayerView {
    
    /// A wrapper View around the ``VideoPlayer`` so we can observe it
    /// and act after a video has finnised playing
    struct Wrapper: View {
        /// The items we want to play
        let items: [MediaItem]
        /// Observe the player
        @StateObject private var playerModel: PlayerModel
        /// Init the Wrapper View
        init(items: [MediaItem], endAction: @escaping () -> Void) {
            _playerModel = StateObject(wrappedValue: PlayerModel(items: items, endAction: endAction))
            self.items = items
        }
        /// The View
        var body: some View {
            
            VideoPlayer(player: playerModel.player) {
                Overlay(item: items.first ?? nil)
            }
            .task {
                /// Check if we are already playing or not
                if playerModel.player.isPlaying == false {
                    //Task {
                        //try await Task.sleep(nanoseconds: 1_000_000_000)
                        playerModel.player.play()
                    //}
                    //sleep(2)
                    
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
                
                /// The NotificationCenter will take care of actions, so set this to .none for the player
                player.actionAtItemEnd = .none
                //                /// Sleep for a moment or else tvOS does not show the metadata
                //                sleep(10)
                //                /// Start the player
                //                player.play()
                /// Get notifications
                NotificationCenter
                    .default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                         object: nil,
                                         queue: nil) { [self] notification in
                        let currentItem = notification.object as? AVPlayerItem
                        /// Get the file location of the item that was played
                        let file = (currentItem?.asset as? AVURLAsset)?.url.absoluteString
                        /// Mark the item as played
                        if var match = KodiConnector.shared.media.first(where: { $0.file == file }) {
                            match.markAsPlayed()
                        }
                        /// Close the window if all items are played or else go to the next item
                        if currentItem == playerItems.last {
                            endAction()
                        } else {
                            player.advanceToNextItem()
                        }
                    }
            }
        }
    }
}
