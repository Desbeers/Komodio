//
//  RouterModel.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

//@MainActor
class Router: ObservableObject {
    
    @Published var routes: [Route] = [.home]
    
    var title: String {
        currentRoute.title
    }
    
    var subtitle: String? {
        routes.dropLast().last?.title
    }
    
    var fanart: String {
        currentRoute.fanart
    }
    
    func push(_ route: Route) {
        /// Need below because `routes` is an `[Enum]`??
        objectWillChange.send()
        routes.append(route)
    }
    
    @discardableResult
    func pop() -> Route? {
        if routes.count > 1 {
            return routes.popLast()
        }
        return nil
    }
    
    @Published var navbar: Route? = .home {
        didSet {
            /// Don't bother with nil's or repeated selection
            if let selection = navbar, selection != oldValue, selection != currentRoute {
                routes = [selection]
            }
        }
    }
    
    var currentRoute: Route {
        routes.last ?? .home
    }
}
