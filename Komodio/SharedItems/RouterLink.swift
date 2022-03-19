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
        Button(action: {
            router.push(item)
        }, label: {
            label
        })
        .id(item.itemID)
    }
}
