//
//  CollectionView+Cell.swift
//  Komodio
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension CollectionView {

    /// SwiftUI `View` for a cell in the collection
    struct Cell: View {
        /// The item to show
        let item: any KodiItem
        /// The sorting
        var sorting: SwiftlyKodiAPI.List.Sort?
        /// Collection style
        let collectionStyle: ScrollCollectionStyle
        /// The cell details
        @State private var cell: KodiCell = .init(title: "", subtitle: "")
        /// The SceneState model
        @Environment(SceneState.self) private var scene
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    if let details = cell.details {
                        withAnimation {
                            scene.detailSelection = details
                        }
                    }
                    if let stack = cell.stack, scene.navigationStack.last != stack {
                        withAnimation {
                            scene.navigationStack.append(stack)
                        }
                    }
                },
                label: {
                    switch collectionStyle {
                    case .asGrid:
                        poster
                    case .asList:
                        list
                    case .asPlain:
                        poster
                    }
                }
            )
            .cellButton(item: item, cell: cell, style: collectionStyle)
            .task {
                switch item {
                case let movie as Video.Details.Movie:
                    cell = MovieView.cell(movie: movie, style: collectionStyle)
                case let movieSet as Video.Details.MovieSet:
                    cell = MovieSetView.cell(movieSet: movieSet, style: collectionStyle)
                case let tvshow as Video.Details.TVShow:
                    cell = TVShowView.cell(tvshow: tvshow, style: collectionStyle)
                case let season as Video.Details.Season:
                    cell = SeasonView.cell(season: season, style: collectionStyle)
                case let episode as Video.Details.Episode:
                    cell = EpisodeView.cell(episode: episode, router: scene.mainSelection)
                case let musicVideo as Video.Details.MusicVideo:
                    cell = MusicVideoView.cell(musicVideo: musicVideo, router: scene.mainSelection)
                case let musicVideoAlbum as Video.Details.MusicVideoAlbum:
                    cell = MusicVideoAlbumView.cell(musicVideoAlbum: musicVideoAlbum, style: collectionStyle)
                case let artist as Audio.Details.Artist:
                    cell = ArtistView.cell(artist: artist, style: collectionStyle)
                default:
                    cell = KodiCell(
                        title: item.title,
                        subtitle: item.subtitle
                    )
                }
            }
        }
        /// The poster of the `View`
        @ViewBuilder var poster: some View {
            KodiArt.Poster(item: item)
                .aspectRatio(contentMode: .fill)
                .watchStatus(of: item)
            #if os(macOS)
                .frame(
                    width: cell.poster.width * (collectionStyle == .asList ? 1 : 2),
                    height: cell.poster.height * (collectionStyle == .asList ? 1 : 2)
                )
            #else
                .frame(width: cell.poster.width, height: cell.poster.height)
            #endif
        }
        /// The fanart of the `View`
        @ViewBuilder var fanart: some View {
            KodiArt.Fanart(item: item)
                .aspectRatio(contentMode: .fit)
                .frame(width: cell.fanart.width, height: cell.fanart.height)
        }
        /// The list of the `View`
        @ViewBuilder var list: some View {
            HStack(spacing: 0) {
                poster
#if os(macOS)
                details
#else
                ViewThatFits {
                    HStack(spacing: 0) {
                        details
                        fanart
                    }
                    details
                }
#endif
            }
            .overlay(alignment: .trailing) {
                if cell.stack != nil {
                    Image(systemName: "chevron.forward")
                        .font(.title3)
                        .padding(.trailing)
                }
            }
        }
        /// The details of the `View`
        @ViewBuilder var details: some View {
            VStack(alignment: .leading) {
                Text(cell.title)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Text(cell.subtitle)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
    }
}
