//
//  DetailsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 08/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct DetailsView: View {

    /// The item to show
    let item: any KodiItem
    /// The View
    var body: some View {
        NavigationView {
            ZStack {
                KodiArt.Fanart(item: item)
                    .frame(width: 1920, height: 1080)
                ScrollView {
                    /// Top row
                    VStack(spacing: 0) {
                        TopView(item: item)
                            .frame(height: UIScreen.main.bounds.height)
                            .focusSection()
                        Details(item: item)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

extension DetailsView {
    
    struct TopView: View {
        let item: any KodiItem
        
        @Environment(\.isFocused) var envFocused: Bool
        var body: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8), .black]),
                               startPoint: .top,
                               endPoint: .bottom)
                //.ignoresSafeArea()
                .frame(height: 210)
                VStack {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        NavigationLink(destination: KodiPlayerView(video: item)) {
                            Label("Play", systemImage: "play.fill")
                                .labelStyle(LabelStyles.DetailsButton())
                        }
                        .buttonStyle(.card)
                        Text(item.title)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 80)
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    struct Details: View {
        let item: any KodiItem
        var body: some View {
            ZStack(alignment: .topLeading) {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack {
                        KodiArt.Poster(item: item)
                            .watchStatus(of: item)
                            .frame(height: 400)
                            .padding(6)
                            .background(.secondary)
                            .cornerRadius(10)
                        VStack(alignment: .leading) {
                            switch item {
                            case let movie as Video.Details.Movie:
                                MovieDetails(movie: movie)
                            case let episode as Video.Details.Episode:
                                EpisodeDetails(episode: episode)
                            case let musicVideo as Video.Details.MusicVideo:
                                MusicVideoDetails(musicVideo: musicVideo)
                            default:
                                Text("No details for this item")
                            }
                            PartsView.WatchedToggle(item: item)
                                .buttonStyle(.card)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal,80)
                .padding(.bottom, 40)
                .focusSection()
            }
        }
    }
}

extension DetailsView {
    struct MovieDetails: View {
        let movie: Video.Details.Movie
        var body: some View {
            Text(movie.tagline)
                .font(.headline)
                .padding()
            Text(movie.plot)
        }
    }
    struct EpisodeDetails: View {
        let episode: Video.Details.Episode
        var body: some View {
            Text(episode.showTitle)
            Text("Season \(episode.season), episode \(episode.episode)")
            Text(episode.plot)
        }
    }
    struct MusicVideoDetails: View {
        let musicVideo: Video.Details.MusicVideo
        var body: some View {
            Text(musicVideo.artist.joined(separator: " & "))
                .font(.title2)
            Text(musicVideo.plot)
        }
    }
}
