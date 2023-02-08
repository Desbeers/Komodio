//
//  PlaylistsView.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

struct PlaylistsView: View {
    /// The KodiConnector model
    @EnvironmentObject private var kodi: KodiConnector

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        HStack {
            if kodi.library.moviePlaylists.isEmpty {
                Text(Router.playlists.empty)
            } else {
                ScrollView {
                    ForEach(kodi.library.moviePlaylists, id: \.file) { playlist in
                        NavigationLink(value: playlist, label: {
                            Label(title: {
                                Text(playlist.title)
                            }, icon: {
                                Image(systemName: Router.playlists.label.icon)
                            })
                        })
                        .padding()
                    }
                }
            }
            DetailView()
                .frame(width: 800)
        }
    }
}
