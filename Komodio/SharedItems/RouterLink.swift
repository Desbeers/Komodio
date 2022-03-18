//
//  RouterLink.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI

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
//#if !os(iOS)
        Button(action: {
            router.push(item)
        }, label: {
            label
        })
//#else
//        NavigationLink(destination: item.destination
//                        .onAppear { router.push(item) }
//                        .iOS { $0.navigationTitle(item.title) }
//                       
//        ) {
//            label
//        }
//#endif
    }
}
