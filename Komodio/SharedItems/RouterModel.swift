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
    
    // MARK: macOS
    
#if os(macOS)
    /// Publish the routes for macOS
    @Published var routes: [Route] = [.home]
    
    func push(_ route: Route) {
        /// Need below because `routes` is an `[Enum]`??
        objectWillChange.send()
        routes.append(route)
    }
    
    @discardableResult
    func pop() -> Route? {
        return routes.popLast()
    }
#endif
    
    // MARK: tvOS
    
#if os(tvOS)
    @Published var routes: [Route] = [.home]
    
    func push(_ route: Route) {
        if routes.contains(route) {
            _ = routes.popLast()
        } else {
            routes.append(route)
        }
    }
    
    @discardableResult
    func pop() -> Route? {
        return routes.popLast()
    }
    
#endif
    
    // MARK: iOS
    
#if os(iOS)
    /// Don't publish it for iOS or else the NavigationLink got nuts
    @Published var routes: [Route] = [.home]
    
    func push(_ route: Route) {
        if routes.contains(route) {
            _ = routes.popLast()
        } else {
            routes.append(route)
        }
    }
    
    @discardableResult
    func pop() -> Route? {
        return routes.popLast()
    }
#endif
    
    // MARK: shared
    
    var title: String {
        currentRoute.title
    }
    
    var subtitle: String? {
        routes.dropLast().last?.title
    }
    
    var fanart: String {
        currentRoute.fanart
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
