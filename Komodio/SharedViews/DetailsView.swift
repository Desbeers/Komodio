//
//  DetailsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI
import Kingfisher

struct DetailsView: View {
    @EnvironmentObject var router: Router
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Kodi item for the details
    @State var item: MediaItem
    /// The View
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                KFImage(URL(string: item.media == .episode ? item.thumbnail : item.fanart)!)
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(12)
                    .shadow(radius: 20)
                VStack {
                    if !item.subtitle.isEmpty {
                        Text(item.subtitle)
                            .font(.headline)
                            .padding(.bottom)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text(item.description)
                }
            }
            /// Give it some padding because the `TitleHeader` is on top in a `ZStack`
            .macOS { $0.padding(.top, 100).padding()}
            .tvOS { $0.padding(.top, 140).padding(.horizontal, 60)}
            .iOS { $0.padding(.top, 120)}
            .frame(maxWidth: .infinity, alignment: .leading)
            //.frame(width: 400)
            Spacer()
            HStack(alignment: .center, spacing: 0) {
                ArtView.Poster(item: item)
                    .cornerRadius(9)
                    .padding(6)
                VStack {
                    /// Buttons
                    HStack {
                        RouterLink(item: .player(items: [item])) {
                            Text("Play")
                        }
                        .padding(.leading)
                        PartsView.WatchedToggle(item: $item)
                        Spacer()
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Divider()
                    .padding(.vertical)
                /// Details
                VStack(alignment: .leading) {
                    Text(item.genres.joined(separator: "・"))
                    Text("Duration: \(item.duration)")
                    Text("Released: \(item.releaseDate.kodiDate(), style: .date)")
                }
                .font(.caption)
                .frame(minWidth: 0, idealWidth: 100)
                .padding()
            }
            .background(.thinMaterial)
            .cornerRadius(12)
            .shadow(radius: 20)
            .macOS { $0.frame(maxHeight: 200).padding() }
            .tvOS { $0.frame(maxHeight: 200).padding(60) }
            .iOS { $0.frame(maxHeight: 200).padding() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: kodi.media ) { _ in
            if let update = kodi.media.first(where: { $0.id == item.id} ) {
                item = update
            }
        }
    }
}
