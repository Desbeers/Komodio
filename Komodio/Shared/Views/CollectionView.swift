//
//  CollectionView.swift
//  Komodio
//
//  Created by Nick Berendsen on 14/08/2023.
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI `View` for a collection of kodi items
struct CollectionView: View {
    /// The collection
    @Binding var collection: [AnyKodiItem]
    /// The sorting
    @Binding var sorting: SwiftlyKodiAPI.List.Sort
    /// The collection style
    let collectionStyle: ScrollCollectionStyle
    /// Bool to show the index
    var showIndex: Bool = true
    /// The items for the collection
    @State private var items = ScrollCollection<AnyKodiItem>()
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ScrollCollectionView(
                collection: items,
                style: collectionStyle,
                anchor: .top,
                grid: StaticSetting.grid,
                showIndex: showIndex,
                header: { header in
                    Text(header.sectionLabel)
                        .font(.headline)
                        .padding(StaticSetting.cellPadding)
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .padding(.bottom, StaticSetting.cellPadding)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                },
                cell: { _, item in
                    Cell(item: item.item, sorting: sorting, collectionStyle: collectionStyle)
                        .scrollTransition(.animated) { content, phase in
                            content
                                .opacity(phase != .identity ? 0.3 : 1)
                        }
                }
            )
        }
        .task(id: collection) {
            let items = collection.map(\.item).sorted(sortItem: sorting)
            self.items = Utils.groupKodiItems(items: items, sorting: sorting)
        }
#if os(tvOS)
        .contentMargins(.horizontal, StaticSetting.cellPadding, for: .scrollContent)
#endif
        .backport.focusSection()
        .animation(.default, value: items.map(\.0))
        .animation(.default, value: collectionStyle)
        .onChange(of: sorting) {
            let items = collection.map(\.item).sorted(sortItem: sorting)
            self.items = Utils.groupKodiItems(items: items, sorting: sorting)
        }
    }
}
