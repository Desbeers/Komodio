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
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Video item we want to play
    @Binding var video: MediaItem
    /// The presentation mode
    /// - Note: Need this to go back a View on iOS after the video has finnished
    @Environment(\.presentationMode) var presentationMode
    /// The body of this View
    var body: some View {
        Wrapper(video: video) {
            /// Mark the video as played
            video.markAsPlayed()
            /// Go back a View
            presentationMode.wrappedValue.dismiss()
        }
    }
}

extension PlayerView {
    
    /// A wrapper View around the `VideoPlayer` so we can observe it
    /// and act after a video has finnised playing
    struct Wrapper: View {
        /// The video we want to play
        //let video: MediaItem
        /// Observe the player
        @StateObject private var playerModel: PlayerModel
        /// Init the Wrapper View
        init(video: MediaItem, endAction: @escaping () -> Void) {
            //self.video = video
            _playerModel = StateObject(wrappedValue: PlayerModel(video: video, endAction: endAction))
        }
        /// The body of this View
        var body: some View {
            VideoPlayer(player: playerModel.player)
                .task {
                    /// Check if we are already playing or not
                    if playerModel.player.isPlaying == false {
                        print("INFO start player")
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
                print("INFO start metadata")
                /// tvOS can add aditional info to the player
                playerItem.externalMetadata = createMetadataItems(video: video)
                print("INFO end metadata")
                /// Create a new Player
                print("INFO create player")
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
}

/// Create meta data for the video player
/// - Parameter video: The Kodi video item
/// - Returns: Meta data for the player
func createMetadataItems(video: MediaItem) -> [AVMetadataItem] {
    /// Helper function
    func createMetadataItem(for identifier: AVMetadataIdentifier, value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        // Specify "und" to indicate an undefined language.
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }
    /// Default poster if Kodi has none
    var artData = UIImage(named: "No Poster")
    /// Try to get the Kodi poster
    if !video.poster.isEmpty, let data = try? Data(contentsOf: URL(string: video.poster)!) {
        if let image = UIImage(data: data) {
            artData = image
        }
    }
    let mapping: [AVMetadataIdentifier: Any] = [
        .commonIdentifierTitle: video.title,
        .iTunesMetadataTrackSubTitle: video.subtitle,
        .commonIdentifierArtwork: artData!.pngData() as Any,
        .commonIdentifierDescription: video.description,
        /// .iTunesMetadataContentRating: "100",
        .quickTimeMetadataGenre: video.genres.joined(separator: "・"),
        .quickTimeMetadataCreationDate: video.releaseDate.kodiDate()
    ]
    return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
}

extension AVPlayer {
    
    /// Is the AV player playing or not?
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
