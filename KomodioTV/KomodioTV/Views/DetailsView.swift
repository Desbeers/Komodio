//
//  DetailsView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Details' SwiftUI View for a 'KodiItem'
struct DetailsView: View {
    /// The item to show
    let item: any KodiItem
    /// The View
    var body: some View {
        NavigationView {
            ZStack {
                KodiArt.Fanart(item: item)
                    .aspectRatio(contentMode: .fill)
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
    
    /// A SwiftUI View for 'KodiItem' details TopView
    struct TopView: View {
        /// The item to show
        let item: any KodiItem
        /// Can we play this item?
        var canPlay: Bool {
            KomodioTVApp.fileExtension.contains(URL(filePath: item.file).pathExtension)
        }
        /// The body of this View
        var body: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5), .black.opacity(0.8), .black]),
                               startPoint: .top,
                               endPoint: .bottom)
                .frame(height: 210)
                VStack(alignment: .leading) {
                    if !canPlay {
                        Label("Komodio cannot play this type of file", systemImage: "lock.square.fill")
                            .font(.headline)
                            .padding()
                            .focusable()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .padding(.horizontal, 80)
                            .padding(.top, 80)
                    }
                    Spacer()
                    HStack(alignment: .bottom) {
                        if canPlay {
                            if item.resume.position != 0 {
                                NavigationLink(destination: KodiPlayerView(video: item, resume: true)) {
                                    Label(title: {
                                        VStack(alignment: .leading) {
                                            Text("Resume")
                                            Text("\(secondsToTime(seconds: item.resume.total - item.resume.position)) to go")
                                                .font(.footnote)
                                        }
                                    }, icon: {
                                        Image(systemName: "play.fill")
                                    })
                                }
                            }
                            NavigationLink(destination: KodiPlayerView(video: item)) {
                                Label(title: {
                                    VStack(alignment: .leading) {
                                        Text("Play")
                                        if item.resume.position != 0 {
                                            Text("From beginning")
                                                .font(.footnote)
                                        }
                                    }
                                }, icon: {
                                    Image(systemName: "play.fill")
                                })
                            }
                        }
                        Text(item.title)
                            .font(.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.white)
                    }
                    .labelStyle(LabelStyles.PlayButton())
                    .buttonStyle(ButtonStyles.DetailsButton())
                    .padding(.horizontal, 80)
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .animation(.default, value: item.playcount)
            .animation(.default, value: item.resume.position)
        }
        /// Convert seconds to time
        private func secondsToTime(seconds: Double) -> String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .brief
            return formatter.string(from: TimeInterval(seconds))!
        }
    }
    
    struct Details: View {
        let item: any KodiItem
        /// The body of this View
        var body: some View {
            ZStack(alignment: .topLeading) {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        KodiArt.Poster(item: item)
                            .watchStatus(of: item)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 400)
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
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .focusable()
                        VStack(alignment: .leading) {
                            if item.resume.position == 0 {
                                PartsView.WatchedToggle(item: item)
                                    .buttonStyle(ButtonStyles.DetailsButton())
                            } else {
                                PartsView.ResumeToggle(item: item)
                                    .buttonStyle(ButtonStyles.DetailsButton())
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 40)
                .focusSection()
            }
            .animation(.default, value: item.playcount)
        }
    }
}

extension DetailsView {
    struct MovieDetails: View {
        let movie: Video.Details.Movie
        var details: String {
            let details = [movie.year.description] + movie.country + movie.genre
            return details.joined(separator: " ∙ ")
        }
        var cast: String {
            var cast: [String] = []
            for person in movie.cast {
                cast.append(person.name)
            }
            return cast.prefix(10).joined(separator: " ∙ ")
        }
        /// The body of this View
        var body: some View {
            if !movie.tagline.isEmpty {
                Text(movie.tagline)
                    .font(.headline)
                    .padding(.bottom)
            }
            Text(movie.plot)
                .padding(.bottom)
            Label(details, systemImage: "info.circle.fill")
                .font(.caption)
                .padding(.bottom)
            if !movie.director.isEmpty {
                Label("Directed by \(movie.director.joined(separator: " ∙ "))", systemImage: "list.bullet.clipboard.fill")
                    .font(.caption)
                    .padding(.bottom)
            }
            Label(cast, systemImage: "person.fill")
                .font(.caption)
        }
    }
    struct EpisodeDetails: View {
        let episode: Video.Details.Episode
        var details: String {
            let show = KodiConnector.shared.library.tvshows.first(where: {$0.tvshowID == episode.tvshowID})
            let details = (show?.studio ?? []) + ["Season \(episode.season)"] + ["Episode \(episode.episode)"]
            return details.joined(separator: " ∙ ")
        }
        /// The body of this View
        var body: some View {
            Text(episode.showTitle)
                .font(.headline)
            Text(details)
                .font(.caption)
            Text(episode.plot)
        }
    }
    struct MusicVideoDetails: View {
        let musicVideo: Video.Details.MusicVideo
        /// The body of this View
        var body: some View {
            Text(musicVideo.year.description)
            Text(musicVideo.artist.joined(separator: " & "))
                .font(.title2)
            Text(musicVideo.plot)
        }
    }
}
