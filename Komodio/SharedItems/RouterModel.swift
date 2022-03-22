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
    
    /// The shared instance of this KodiConnector class
    public static let shared = Router()
    
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
        
        if route.itemID.isEmpty {
            /// Remove the selection; it is not relevant for the next View
            setSelectedMediaItem(item: nil)
        } else {
            /// Store the last selected item
            routes[routes.endIndex-1].itemID = route.itemID
        }
        /// Push the new View
        routes.append(RouteItem(route: route, itemID: route.itemID))
    }
    
    @discardableResult
    func pop() -> RouteItem? {
        if routes.count > 1 {
            /// Remove the selection if not relevant
//            if routes[routes.endIndex-2].itemID.isEmpty {
//                setSelectedMediaItem(item: nil)
//            }
            /// Pop to the previous View
            return routes.popLast()
        }
        return nil
    }
    
    var currentRoute: RouteItem {
        routes.last ?? RouteItem()
    }
    
    private init() {}
}
