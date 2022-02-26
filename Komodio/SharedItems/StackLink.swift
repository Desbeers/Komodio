//
//  StackLink.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

public struct StackLink<Label: View, Destination: View>: View {
    public init(path: String, filter: Binding<KodiFilter>, destination: Destination, @ViewBuilder label: () -> Label) {
        self.path = path
        self._filter = filter
        self.label = label()
        self.destination = destination
    }
    
    
    private var path: String
    @Binding private var filter: KodiFilter
    private var label: Label
    private var destination: Destination
    
    public var body: some View {
#if os(macOS)
        NavLink(to: path) {
            label
        }
        
        
#elseif os(iOS)
        NavigationLink(destination: destination.navigationTitle(title)) {
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
