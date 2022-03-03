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
#else
    /// Don't publish it for iOS or else the NavigationLink will pop back
    var routes: [Route] = [.home]
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

    func push(_ route: Route) {
        debugPrint("Push \(route.title)")
        //objectWillChange.send()
        routes.append(route)
    }
    
    //@discardableResult
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
        NavigationLink(destination: item.destination
                        .iOS { $0.navigationTitle(item.title) }
//                        .task {
//            print("Appear: \(item.title), push it")
//            router.routes.append(item)
//        }
//                        .onDisappear {
//            print("Dissapear: \(item.title), pop it")
//            let _ = router.routes.popLast()
//        }
        
        ) {
            label
        }
#endif
    }
}
