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
    /// The sorting
    @State private var sort: SwiftlyKodiAPI.List.Sort = .init()
    /// The body of the `View`
    var body: some View {
        ScrollCollectionView(
            collection: items,
            style: collectionStyle,
            anchor: .top,
            grid: StaticSetting.grid,
            showIndex: showIndex,
            header: { header in
                Text(header.sectionLabel)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .padding(.bottom, StaticSetting.cellPadding)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            },
            cell: { _, item in
                Cell(item: item.item, sorting: sort, collectionStyle: collectionStyle)
            }
        )
        .task(id: collection) {
            sort = sorting
            let items = collection.map(\.item).sorted(sortItem: sorting)
            self.items = Utils.groupKodiItems(items: items, sorting: sorting)
        }
        .backport.focusSection()
        .animation(.default, value: collection)
        .animation(.default, value: items.map(\.0))
        .animation(.default, value: collectionStyle)
        .onChange(of: sorting) { newSort in
            let items = collection.map(\.item).sorted(sortItem: sorting)
            self.items = Utils.groupKodiItems(items: items, sorting: newSort)
            self.sort = newSort
        }
    }
}
