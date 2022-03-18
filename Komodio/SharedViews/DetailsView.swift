//
//  DetailsView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

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
            HStack(alignment: .top, spacing: 0) {
                ArtView.PosterDetail(item: item)
                    .cornerRadius(9)
                    .shadow(radius: 6)
                    .padding(6)
                VStack {
                    if !item.subtitle.isEmpty {
                        Text(item.subtitle)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    /// Description
                    Text(item.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    /// Buttons
                    HStack {
                        RouterLink(item: .player(items: [item])) {
                            Text("Play")
                        }
                        PartsView.WatchedToggle(item: $item)
                        Spacer()
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding()
                Divider()
                    .padding(.vertical)
                /// Details
                VStack(alignment: .leading) {
                    Text(item.genres.joined(separator: "・"))
                    Text("Duration: \(item.duration)")
                    Text("Released: \(item.releaseDate.kodiDate(), style: .date)")
                    Spacer()
                }
                .font(.caption)
                .frame(minWidth: 0, idealWidth: 100)
                
                .padding()
            }
            .background(.thinMaterial)
            .cornerRadius(12)
            .shadow(radius: 20)
            .macOS { $0.frame(maxHeight: 200).padding() }
            .tvOS { $0.frame(maxHeight: 300).padding(60) }
            .iOS { $0.frame(maxHeight: 200).padding() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ArtView.Fanart(fanart: item.fanart)
                .ignoresSafeArea()
        }
        .onChange(of: kodi.media ) { _ in
            if let update = kodi.media.first(where: { $0.id == item.id} ) {
                item = update
            }
        }
    }
}
