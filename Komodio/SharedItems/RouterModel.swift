//
//  RouterModel.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

//@MainActor
class Router: ObservableObject {
    
    /// The selected media item
    @Published var selectedMediaItem: MediaItem?
    
    func setSelectedMediaItem(item: MediaItem?) {
        //let _ = print("\(item?.title) has focus")
        //Task { @MainActor in
            selectedMediaItem = item
        //}
    }
    
    //@Published var routes: [Route] = [.home]
    
    @Published var routes: [RouteItem] = [RouteItem()]
    
    struct RouteItem: Equatable {
        var route: Route = .home
        var itemID: String = "home"
    }
    
    var title: String {
        currentRoute.route.title
    }
    
    var subtitle: String? {
        routes.dropLast().last?.route.title
    }
    
    var fanart: String {
        currentRoute.route.fanart
    }
    
    func push(_ route: Route) {
        /// Store the last selected item
        routes[routes.endIndex-1].itemID = route.itemID
        /// Remove the selection
        //setSelectedMediaItem(item: nil)
        /// Push the new View
        routes.append(RouteItem(route: route, itemID: route.itemID))
    }
    
    @discardableResult
    func pop() -> RouteItem? {
        if routes.count > 1 {
            /// Remove the selection
            //setSelectedMediaItem(item: nil)
            /// Pop the previous View
            return routes.popLast()
        }
        return nil
    }
    
    var currentRoute: RouteItem {
        routes.last ?? RouteItem()
    }
}
