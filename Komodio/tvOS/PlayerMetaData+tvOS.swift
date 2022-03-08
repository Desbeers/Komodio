//
//  PlayerMetaData.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import AVKit
import SwiftlyKodiAPI

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
        .iTunesMetadataTrackSubTitle: video.subtitle as Any,
        .commonIdentifierArtwork: artData!.pngData() as Any,
        .commonIdentifierDescription: video.description,
        /// .iTunesMetadataContentRating: "100",
        .quickTimeMetadataGenre: video.genres.joined(separator: "・"),
        .quickTimeMetadataCreationDate: video.releaseDate.kodiDate()
    ]
    return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
}
