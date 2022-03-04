//
//  DetailsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

struct DetailsView: View {    
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    
    /// The Router model
    @EnvironmentObject var router: Router
    
    /// The Kodi item for the details
    @Binding var item: KodiItem
    /// The View
    var body: some View {
        VStack(spacing: 0) {
            #if os(tvOS)
            PartsView.TitleHeader(router: $router.routes)
            #endif
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
                    Spacer()
                    /// Buttons
                    HStack {
                        PlayerView.Link(item: item, destination: PlayerView(video: item)) {
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
                    Text(item.genres)
                    Text("Duration: \(item.duration)")
                    Text("Released: \(item.releaseDate, style: .date)")
                    Spacer()
                }
                .font(.caption)
                .frame(minWidth: 0, idealWidth: 100)
                
                .padding()
            }
            .background(.thinMaterial)
            .cornerRadius(12)
            .shadow(radius: 20)
            .macOS { $0.padding().frame(maxHeight: 200) }
            .tvOS { $0.frame(maxHeight: 300).padding(60) }
            .iOS { $0.frame(maxHeight: 200).padding(.horizontal) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ArtView.Fanart(fanart: item.fanart)
                .macOS {$0.edgesIgnoringSafeArea(.all) }
                .tvOS { $0.edgesIgnoringSafeArea(.all) }
                .iOS { $0.edgesIgnoringSafeArea(.bottom) }
        }
        .task {
            print("DetailsView task!")
            appState.filter.subtitle = item.subtitle.isEmpty ? appState.filter.title : item.subtitle
            appState.filter.title = item.title
        }
        .tvOS { $0.ignoresSafeArea() }
        .macOS { $0.ignoresSafeArea() }
        .iOS { $0.ignoresSafeArea(.all, edges: .bottom) }
        .iOS { $0.navigationTitle(item.title) }
    }
}
