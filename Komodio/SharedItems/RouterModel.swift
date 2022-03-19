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
    
    //@Published var routes: [Route] = [.home]
    
    @Published var routes: [RouteItem] = [RouteItem()]
    
    struct RouteItem: Equatable {
        var route: Route = .home
        var itemID: String = ""
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
        /// Need below because `routes` is an `[Enum]`??
        //objectWillChange.send()
        
        //logger("Push, id = \(route.itemID)")
        
        routes[routes.endIndex-1].itemID = route.itemID
        
        routes.append(RouteItem(route: route, itemID: route.itemID))
    }
    
    @discardableResult
    func pop() -> RouteItem? {
        if routes.count > 1 {
            return routes.popLast()
        }
        return nil
    }
    
    var currentRoute: RouteItem {
        routes.last ?? RouteItem()
    }
}
