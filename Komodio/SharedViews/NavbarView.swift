//
//  SidebarView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI



#if os(macOS)
/// The View for the Sidebar
struct NavbarView: View {
    /// The Router model
    @EnvironmentObject var router: Router
    /// The View
    var body: some View {
        List(selection: $router.navbar) {
            Section(header: Text("Library")) {
                NavbarView.Items(selection: $router.navbar)
            }
        }
    }
}
#endif

#if os(iOS)
/// The View for the Sidebar
struct NavbarView: View {
    /// The selection
    @State var selection: Route?
    /// The View
    var body: some View {
        List {
            NavbarView.Items(selection: $selection)
        }
        .navigationTitle("Library")
    }
}
#endif

#if os(tvOS)
struct NavbarView {}
#endif

extension NavbarView {
    
    /// A View with 'standard' items for a Sidebar or Tabbar
    struct Items: View {
        /// The Router model
        @EnvironmentObject var router: Router
        /// The selection
        @Binding var selection: Route?
        /// The view
        var body: some View {

                ForEach(Route.menuItems, id: \.self) { item in
#if os(macOS)
                    Label(item.title, systemImage: item.symbol)
#endif

#if os(tvOS)
                    item.destination
                        .tabItem {
                            Label(item.title, systemImage: item.symbol)
                        }
                        .tag(item.title)
#endif

#if os(iOS)
                    NavigationLink(destination: item.destination
                                    //.onAppear { router.routes = [item] }
                                    .navigationTitle(item.title),
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
