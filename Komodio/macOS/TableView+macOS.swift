//
//  TableView.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A table View of Kodi items; for debug...
struct TableView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The list of items
    @State var items: [MediaItem] = []
    /// Sort order for the table
    @State var sortOrder: [KeyPathComparator<MediaItem>] = [ .init(\.title, order: SortOrder.forward)]
    /// The View
    var body: some View {
        Table(sortOrder: $sortOrder) {
            TableColumn("Media", value: \.media.rawValue)
            TableColumn("ID", value: \.id)
            TableColumn("Title", value: \.title)
            TableColumn("Subtitle", value: \.subtitle)
            TableColumn("Description", value: \.description)
//            TableColumn("Playcount", value: \.playcount) { item in
//                Text("\(item.playcount)")
//            }
            //            TableColumn("Playcount", value: \.playcount) { item in
            //                Text("\(item.playcount)")
            //            }
            //            TableColumn("Year", value: \.releaseYear)
            //            TableColumn("Date", value: \.releaseDate) { item in
            //                Text(item.releaseDate, style: .date)
            //            }
            //            TableColumn("Subtitle", value: \.subtitle)
            //            TableColumn("Description", value: \.description)
            //            TableColumn("Details", value: \.details)
            //            TableColumn("Duration", value: \.duration)
        } rows: {
            ForEach(kodi.media.sorted(using: sortOrder)) { item in
                TableRow(item)
            }
        }
        .padding(.top, 40)
    }
}