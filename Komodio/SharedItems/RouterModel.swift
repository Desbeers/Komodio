//
//  RouterModel.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI

class Router: ObservableObject {
    
#if os(macOS)
    /// Publish the routes for macOS
    @Published var routes: [Route] = [.home]

    @MainActor func push(_ route: Route) {
        debugPrint("Push \(route.title)")
        /// Need below because `routes` is an `Enum`??
        objectWillChange.send()
        routes.append(route)
    }
    
    @discardableResult
    @MainActor func pop() -> Route? {
        debugPrint("Pop \(currentRoute.title)")
        return routes.popLast()
    }
    #endif
    
#if os(tvOS)
    @Published var routes: [Route] = [.home]

    func push(_ route: Route) {
        
        if routes.contains(route) {
            debugPrint("\(route) already in the stack")
            
            //let index = routes.firstIndex(of: route)
            
            _ = routes.popLast()
        } else {
            debugPrint("\(route) new in the stack")
            routes.append(route)
        }
        
        //debugPrint("Push \(route.title)")
        //debugPrint("Push enum \(route)")
        //routes.append(route)
        dump(routes, maxDepth: 1)
    }
    
    @discardableResult
    func pop(_ route: Route) -> Route? {
        objectWillChange.send()
        debugPrint("Pop argument \(currentRoute.title)")
        debugPrint("Pop current \(currentRoute.title)")
        
        if routes.count > 1 {
            
            return routes.popLast()
            
        } else {
            return nil
        }
    }
    #endif
    
#if os(iOS)
    /// Don't publish it for iOS or else the NavigationLink got nuts
    var routes: [Route] = [.home]

    func push(_ route: Route) {
        debugPrint("Push \(route.title)")
        debugPrint("Push enum \(route)")
        routes.append(route)
        dump(routes, maxDepth: 1)
    }
    
    @discardableResult
    func pop(_ route: Route) -> Route? {
        objectWillChange.send()
        debugPrint("Pop argument \(currentRoute.title)")
        debugPrint("Pop current \(currentRoute.title)")
        
        if routes.count > 1 {
            
            return routes.popLast()
            
        } else {
            return nil
        }
    }

#endif
    
    var title: String {
        currentRoute.title
    }
    
    var subtitle: String? {
        routes.dropLast().last?.title
    }
    
    var fanart: String = ""
    
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

struct RouterLink<Label: View>: View {
    
    @EnvironmentObject var router: Router
    
    private var item: Route
    private var label: Label
    /// Init the RouterLink
    init(item: Route, @ViewBuilder label: () -> Label) {
        self.item = item
        self.label = label()
    }
    /// The View
    var body: some View {
#if os(macOS)
        Button(action: {
            router.push(item)
        }, label: {
            label
        })
#else
        NavigationLink(destination: item.destination
                        .iOS { $0.navigationTitle(item.title) }
                        .onAppear { router.push(item) }
                        //.onDisappear { router.pop(item) }
        
        ) {
            label
        }
#endif
    }
}
