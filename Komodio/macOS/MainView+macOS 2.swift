//
//  MainView.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct MainView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        ZStack(alignment: .top) {
            DestinationView(route: router.currentRoute)
            //router.currentRoute.destination
            VStack {
                PartsView.TitleHeader()
                Spacer()
            }
        }
        .fanartBackground(fanart: router.fanart)
        .animation(.default, value: router.currentRoute)
    }
}

struct DestinationView: View {
    
    let route: Route
    
    var body: some View {
        switch route {
        case .home:
            HomeView()
        case .movies:
            MoviesView()
        case .moviesSet(let set):
            MoviesView.Set(set: set)
        
        case .tvshows:
            TVshowsView(filter: KodiFilter(media: .tvshow))
        case .episodes(let tvshow):
            EpisodesView(tvshow: tvshow)
        
        case .musicVideos:
            MusicVideosView(filter: KodiFilter(media: .musicvideo))
        case .musicVideosItems(let artist):
            MusicVideosView.Items(artist: artist)
        
        
        case .genres:
            GenresView()
        case .genresItems(let genre):
            GenresView.Items(genre: genre)
        case .details(let item):
            DetailsView(item: item.binding())
        default:
            Text("TODO")
        }
    }
}
