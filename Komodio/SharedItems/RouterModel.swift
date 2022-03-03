//
//  RouterModel.swift
//  Router
//
//  Created by Nick Berendsen on 02/03/2022.
//

import SwiftUI
import SwiftlyKodiAPI



struct RouteItem {
    let id = UUID()
    let name: String
    let symbol: String
}

class Router: ObservableObject {
    
    @Published var routes: [Route] = [.home]
    
    var selection: Route = .home
    
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
    
    @MainActor func push(_ route: Route) {
        debugPrint("Push \(route.title)")
        routes.append(route)
    }
    
    @discardableResult
    @MainActor func pop() -> Route? {
        routes.popLast()
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
        NavigationLink(destination: item.destination.navigationTitle(item.rawValue)) {
            label
        }
#endif
    }
}
