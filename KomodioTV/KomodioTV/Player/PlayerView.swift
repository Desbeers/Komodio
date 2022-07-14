//
//  PlayerView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 11/07/2022.
//

import SwiftUI
import Combine
import AVKit
import SwiftlyKodiAPI

struct PlayerView: View {
    @StateObject private var playerModel: PlayerModel
    
    init(video: any KodiItem) {
        _playerModel = StateObject(wrappedValue: PlayerModel(video: video))
    }
    
    //let video: any KodiItem
    
    var body: some View {
        UIVideoPlayer(player: playerModel.player)
            .onAppear {
                playerModel.player.play()
            }
            .onDisappear {
                playerModel.player.pause()
            }
            .ignoresSafeArea()
    }
}

final class PlayerModel: ObservableObject {
    let player: AVQueuePlayer
    /// Setup the player
    init(video: any KodiItem) {
        
        let playerItem = AVPlayerItem(url: URL(string: Files.getFullPath(file: video.file, type: .file))!)
        
        playerItem.externalMetadata = createMetadataItems(video: video)
        
        player = AVQueuePlayer(items: [playerItem])
        
        
        //player = AVPlayer(playerItem: playerItem)
        
        //self.player = AVPlayer()
    }
}

/// Create meta data for the video player
/// - Parameter video: The Kodi video item
/// - Returns: Meta data for the player
func createMetadataItems(video: any KodiItem) -> [AVMetadataItem] {

    /// Meta data struct
    struct MetaData {
        var title: String = "title"
        var subtitle: String = "subtitle"
        var description: String = "description"
        var genre: String = "genre"
        var creationDate: String = "1900"
        var artwork: UIImage = UIImage(named: "poster")!
    }

    /// Helper function
    func createMetadataItem(for identifier: AVMetadataIdentifier, value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        /// Specify "und" to indicate an undefined language.
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }

    var metaData = MetaData()

    switch video {
    case let movie as Video.Details.Movie:
        metaData.title = movie.title
        metaData.subtitle = movie.tagline
        metaData.description = movie.plot
        if !movie.art.poster.isEmpty, let data = try? Data(contentsOf: URL(string: Files.getFullPath(file: movie.art.poster, type: .art))!) {
            if let image = UIImage(data: data) {
                metaData.artwork = image
            }
        }
        metaData.genre = movie.genre.joined(separator: " ∙ ")
        metaData.creationDate = movie.year.description
    case let episode as Video.Details.Episode:
        metaData.title = episode.title
        metaData.subtitle = episode.showTitle
        metaData.description = episode.plot
        if !episode.art.seasonPoster.isEmpty, let data = try? Data(contentsOf: URL(string: Files.getFullPath(file: episode.art.seasonPoster, type: .art))!) {
            if let image = UIImage(data: data) {
                metaData.artwork = image
            }
        }
        metaData.genre = episode.showTitle
        metaData.creationDate = episode.firstAired
//    case let musicVideo as Video.Details.MusicVideo:
    default:
        break
    }
    let mapping: [AVMetadataIdentifier: Any] = [
        .commonIdentifierTitle: metaData.title,
        .iTunesMetadataTrackSubTitle: metaData.subtitle,
        .commonIdentifierArtwork: metaData.artwork.pngData() as Any,
        .commonIdentifierDescription: metaData.description,
        /// .iTunesMetadataContentRating: "100",
        .quickTimeMetadataGenre: metaData.genre,
        .quickTimeMetadataCreationDate: metaData.creationDate
        //.commonIdentifierTitle: video.title,
        //.iTunesMetadataTrackSubTitle: video.subtitle,
        //.commonIdentifierArtwork: artData!.pngData() as Any,
        //.commonIdentifierDescription: video.description,
        /// .iTunesMetadataContentRating: "100",
        //.quickTimeMetadataGenre: video.genres.joined(separator: "・"),
        //.quickTimeMetadataCreationDate: video.releaseDate.kodiDate()
    ]
    return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
}
