//
//  DetailsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 08/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct DetailsView: View {
//    init(item: any KodiItem) {
//        self.item = item
//        self.kodiItem = item
//    }
    
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    let item: any KodiItem
    //@State private var kodiItem: (any KodiItem)?
    var body: some View {
        ZStack {
            BackgroundView(item: item)
            NavigationView {
                ScrollView {
                    /// Top row
                    VStack(spacing: 0) {
                        TopView(item: item)
                            .frame(height: UIScreen.main.bounds.height)
                            .focusSection()
                        //Details(item: kodiItem == nil ? item : kodiItem)
                        Details(item: item)
                    }
                }
            }
        }
    }
}

extension DetailsView {
    struct BackgroundView: View {
        let item: any KodiItem
        var body: some View {
            AsyncImage(url: URL(string: item.media == .episode ? item.poster : Files.getFullPath(file: item.fanart, type: .art))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .ignoresSafeArea()
            .frame(width: 1920, height: 1080)
        }
    }

    
    struct TopView: View {
        let item: any KodiItem
        
        @Environment(\.isFocused) var envFocused: Bool
        var body: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8), .black]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                .frame(height: 210)
                VStack {
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        PartsView.WatchedToggle(item: item)
                            .buttonStyle(.card)
                        NavigationLink(destination: PlayerView(video: item)) {
                            Label("Play", systemImage: "play.fill")
                                .labelStyle(LabelStyles.DetailsButton())
                        }
                        .buttonStyle(.card)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.title)
                                .font(.title2)
                            Text("Playcount: \(item.playcount)")
                        }
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
                        PosterView(item: item)
                        Text(item.title)
                        PartsView.WatchedToggle(item: item)
                            .buttonStyle(.card)
                    }
                }
                .padding(.horizontal,80)
                .padding(.bottom, 40)
                .focusSection()
            }
        }
    }
    
    struct PosterView: View {
        let item: any KodiItem
        var body: some View {
            AsyncImage(url: URL(string: Files.getFullPath(file: item.poster, type: .art))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray
            }
            .frame(height: 400)
            .padding(6)
            .background(.secondary)
            .cornerRadius(10)
        }
    }
}
