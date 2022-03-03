//
//  SidebarView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI


/// The View for the Sidebar
struct NavbarView: View {
    
    /// The Router model
    @EnvironmentObject var router: Router
    
    var body: some View {
        List(selection: $router.navbar) {
            Section(header: Text("Library")) {
                NavbarView.Items(selection: $router.navbar)
            }
        }
        .navigationTitle("Library")
    }
}

extension NavbarView {
    
    /// A View with 'standard' items for a Sidebar or Tabbar
    struct Items: View {
        /// The selection
        @Binding var selection: Route?
        /// The view
        var body: some View {

                ForEach(Route.menuItems, id: \.self) { item in
#if os(macOS)
                    Label(item.title, systemImage: item.symbol)
#else
                    NavigationLink(destination: item.destination,
                                   tag: item,
                                   selection: $selection,
                                   label: { Label(item.title, systemImage: item.symbol) })
#endif
                }
            
        }
    }
    
    //    /// A View for the Sidebar with all the genres from the Kodi host
    //    struct Genres: View {
    //        /// The KodiConnector model
    //        @EnvironmentObject var kodi: KodiConnector
    //        /// The binding for the list
    //        @Binding var selection: String?
    //        /// The view
    //        var body: some View {
    //            ForEach(kodi.genres) { genre in
    //                Label(genre.label, systemImage: genre.symbol)
    //                    .tag("\(genre.label)")
    //            }
    //        }
    //    }
}
