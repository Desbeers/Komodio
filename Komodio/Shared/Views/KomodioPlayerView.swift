//
//  KomodioPlayerView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Komodio Player View

/// SwiftUI `View` for a video player (shared)
///
/// Currently, Komodio is using the `AVPlayer` from the SwiftlyKodiAPI package
///
/// It can only play 'Apple Approved' formats, so no *MKV*'s
///
/// It is my intension to replace this sooner or later, but for now, it is as it is.
///
/// It will give a warning if it can't play the file
struct KomodioPlayerView: View {
    /// The Video item we want to play
    let video: any KodiItem
    /// Resume the video or not
    var resume: Bool = false

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        switch KomodioPlayerView.canPlay(video: video) {
        case true:
            KodiPlayerView(video: video, resume: resume)
        case false:
            warning
        }
    }
    /// The warning if we can't play a video
    var warning: some View {
        ZStack {
            KodiArt.Fanart(item: video)
            CantPlay(video: video)
                .font(.title)
                .padding()
                .backport.focusable()
                .background(.thinMaterial)
                .cornerRadius(10)
                .padding(.horizontal, 80)
                .padding(.top, 80)
        }
    }
}

// MARK: Extensions

extension KomodioPlayerView {

    // MARK: Komodio Player Cant Play

    /// SwiftUI `View` for message that we can't play a video
    struct CantPlay: View {
        /// The video that we can't play
        let video: any KodiItem
        /// Details of the message
        var details: String {
            "'\(URL(filePath: video.file).pathExtension)' files are not supported…"
        }

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            Button(action: {
                // No action
            }, label: {
                Buttons.formatButtonLabel(
                    title: "**Komodio** can't play this video",
                    subtitle: details,
                    icon: "lock.square.fill")
            })
        }
    }

    /// Check if we can play a video or not
    /// - Parameter video: The video item
    /// - Returns: True or False
    static func canPlay(video: any KodiItem) -> Bool {

        // swiftlint:disable line_length

        /// The files Komodio can play
        let fileExtension: [String] = ["caf", "ttml", "au", "ts", "mqv", "pls", "flac", "dv", "amr", "mp1", "mp3", "ac3", "loas", "3gp", "aifc", "m2v", "m2t", "m4b", "m2a", "m4r", "aa", "webvtt", "aiff", "m4a", "scc", "mp4", "m4p", "mp2", "eac3", "mpa", "vob", "scc", "aax", "mpg", "wav", "mov", "itt", "xhe", "m3u", "mts", "mod", "vtt", "m4v", "3g2", "sc2", "aac", "mp4", "vtt", "m1a", "mp2"]

        // swiftlint:enable line_length

        return fileExtension.contains(URL(filePath: video.file).pathExtension)
    }
}
