//
//  DetailsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 24/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// View details for a media item
struct DetailsView: View {
    /// The media item for the details
    @Binding var item: MediaItem
    /// The View
    var body: some View {
        ZStack {
            BackgroundView(item: item)
            ScrollView {
                /// Top row
                VStack(spacing: 0) {
                    TopView(item: $item)
                        .frame(height: UIScreen.main.bounds.height)
                        .focusSection()
                    /// Details row
                    ZStack(alignment: .topLeading) {
                        Color.black.ignoresSafeArea()
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                PosterView(item: $item)
                                VStack(alignment: .leading) {
                                    if !item.description.isEmpty {
                                        AboutView(item: $item)
                                    }
                                    if !item.cast.isEmpty {
                                        CastView(cast: item.cast)
//                                        let cast = item.cast.map(\.name)
//                                        Text("Cast:")
//                                            .font(.callout)
//                                            .padding(.top)
//                                        Text(cast.joined(separator: ", "))
//                                            .font(.caption)
//                                            .padding(.horizontal)
                                    }
                                    //let video = item.streamDetails.video.map(\.height)
                                    Text("Video:")
                                        .font(.callout)
                                        .padding(.top)
                                    Text("\(item.streamDetails.video.first?.width ?? 0)")
                                        .font(.caption)
                                        .padding(.horizontal)
                                    let audio = item.streamDetails.audio.map(\.codec)
                                    Text("Audio:")
                                        .font(.callout)
                                        .padding(.top)
                                    Text(audio.joined(separator: ", "))
                                        .font(.caption)
                                        .padding(.horizontal)
                                    /// Subtitles
                                    if !item.streamDetails.subtitle.isEmpty {
                                        Text("Subtitles:")
                                            .font(.callout)
                                            .padding(.top)
                                        
                                        
                                        ForEach(item.streamDetails.subtitle) {subtitle in
                                            HStack {
                                            if subtitle.language.isEmpty {
                                                Text("External")
                                            } else {
                                                Text(countryName(from: subtitle.language))
                                            }
                                                     }
                                            .font(.caption)
                                            .padding(.horizontal)
                                        }
//
//                                        Text(subtitles.joined(separator: ", "))
//                                            .font(.caption)
//                                            .padding(.horizontal)
                                    }
                                    
                                    ActionsView(item: $item)
                                        .padding(.top)
                                }
                                /// Make sure the poster is always shown
                                .frame(maxWidth: .infinity, minHeight: 560, alignment: .leading)
                            }
                        }
                        .padding(.horizontal,80)
                        .focusSection()
                    }
                }
            }
        }
    }
}

extension DetailsView {
    
    struct TopView: View {
        @Binding var item: MediaItem
        
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
                        NavigationLink(destination: PlayerView(video: $item)) {
                            Label("Play", systemImage: "play.fill")
                                .labelStyle(LabelStyles.DetailsItem())
                        }
                        .buttonStyle(.card)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.title)
                                .font(.title2)
                            Text(item.details)
                        }
                    }
                    .padding(.horizontal, 80)
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    struct AboutView: View {
        @Binding var item: MediaItem
        @Environment(\.isFocused) var isFocused: Bool
        var body: some View {
            Text(item.description)
            
        }
    }
    
    struct ActionsView: View {
        @Binding var item: MediaItem
        var body: some View {
            PartsView.WatchedToggle(item: $item)
                .buttonStyle(.card)
        }
    }
    
    struct PosterView: View {
        @Binding var item: MediaItem
        var body: some View {
            AsyncImage(url: URL(string: item.poster)) { image in
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
    
    struct BackgroundView: View {
        let item: MediaItem
        var body: some View {
            AsyncImage(url: URL(string: item.fanart)) { image in
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
    
    struct CastView: View {
        let cast: [ActorItem]
        var body: some View {
            let _ = print(cast)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                ForEach(cast) { item in
                    VStack {
                        ArtView.ActorIcon(item: item.icon)
                    Text(item.name)
                    }
                }
                }
            }
        }
    }
}


func countryName(from countryCode: String) -> String {
    if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
        // Country name was found
        return name
    } else {
        // Country name cannot be found
        return countryCode
    }
}
