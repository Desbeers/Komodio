//
//  StackLink.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

/// A replacement for ``NavigationView``
struct StackNavView<Content: View>: View {
    private var content: Content
    /// StackNavView
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    ///The View
    public var body: some View {
        
#if os(macOS)
        NavigationView {
            content
        }
#endif
        
#if os(tvOS)
        NavigationView {
            content
        }
#endif
        
#if os(iOS)
        NavigationView {
            content
        }
#endif
        
    }
}

public struct StackNavItem<Destination, V: Hashable> : View where Destination : View {
    /// The title of the link
    var title: String
    /// The icon of the link
    var icon: String
    /// The destination of the link
    var destination: Destination
    /// The tag of the link
    var tag: V?
    /// The selection binding of the link
    var selection: Binding<V?>?
    /// Init the StackNavItem
    public init(title: String, icon: String, destination: Destination, tag: V, selection: Binding<V?>) where V : Hashable {
        self.destination = destination
        self.tag = tag
        self.selection = selection
        self.title = title
        self.icon = icon
    }
    /// The View
    public var body: some View {
        
#if os(macOS)
        Label(title, systemImage: icon)
            .tag(title)
#endif
        
#if os(iOS)
        if let tag = tag, let selection = selection {
            NavigationLink(destination: destination,
                           tag: tag,
                           selection: selection,
                           label: { Label(title, systemImage: icon) })
        }
#endif
        
#if os(tvOS)
        /// tvOS has no Navigationlinks but tabs
        destination
            .tabItem {
                Label(title, systemImage: icon)
            }
            .tag(title)
#endif
        
    }
}


public struct StackNavLink<Label: View, Destination: View>: View {
    private var path: String
    private var filter: KodiFilter
    private var label: Label
    private var destination: Destination
    /// Init the StackNavLink
    public init(path: String, filter: KodiFilter, destination: Destination, @ViewBuilder label: () -> Label) {
        self.path = path
        self.filter = filter
        self.label = label()
        self.destination = destination
    }
    
    
    public var body: some View {
#if os(macOS)
        NavLink(to: path) {
            label
        }
#elseif os(iOS)
        NavigationLink(destination: destination) {
            label
        }
#elseif os(tvOS)
        /// .navigationTitle is a mess on tvOS; so up to the View to add something...
        NavigationLink(destination: destination) {
            label
        }
#endif
    }
}

// - MARK: Transitions

struct NavigationTransition: ViewModifier {
    @EnvironmentObject private var navigator: Navigator
    
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut, value: navigator.path)
            .transition(
                navigator.lastAction?.direction == .deeper || navigator.lastAction?.direction == .sideways
                ? AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
                : AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
            )
    }
}

extension View {
    func navigationTransition() -> some View {
        modifier(NavigationTransition())
    }
}
