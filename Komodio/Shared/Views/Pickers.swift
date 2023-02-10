//
//  Pickers.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Collection of SwiftUI Pickers (shared)
enum Pickers {
    // Just a namespace here
}

extension Pickers {

    /// Sort a list: Two pickers to select the method and order
    struct ListSortPicker: View {
        /// The current sorting
        @Binding var sorting: ListSort.Item
        /// The kind of media
        let media: Library.Media
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
                Picker(selection: $sorting.method, label: Text("Sort method")) {
                    ForEach(ListSort.SortMethod.allCases, id: \.rawValue) { method in
                        Text(method.rawValue)
                            .tag(method)
                    }
                }
                Picker(selection: $sorting.order, label: Text("Sort order")) {
                    ForEach(ListSort.SortOrder.allCases, id: \.rawValue) { order in
                        Text(order.label(method: sorting.method))
                            .tag(order)
                    }
                }
                .pickerStyle(.segmented)
            }
            .onChange(of: sorting) { item in
                if let index = scene.listSortSettings.firstIndex(where: {$0.id == sorting.id}) {
                    scene.listSortSettings[index] = item
                } else {
                    scene.listSortSettings.append(item)
                }
                ListSort.save(settings: scene.listSortSettings)
            }
            .labelsHidden()
        }
    }

    /// SwiftUI Button to show the ``Pickers/ListSortPicker`` in a Sheet
    /// - Note: Used for tvOS or else the UI will be too cluttered
    struct ListSortSheet: View {
        /// The current sorting
        @Binding var sorting: ListSort.Item
        /// The kind of media
        let media: Library.Media
        /// Bool to show the sSheet
        @State private var showSheet: Bool = false

        // MARK: Body of the View

        /// The body of the View

        var body: some View {
            Button(action: {
                showSheet = true
            }, label: {
                Label(title: {
                    Text("\(sorting.method.rawValue)∙\(sorting.order.label(method: sorting.method))")
                        .padding()
                }, icon: {
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(.leading)
                })
            })
            .sheet(isPresented: $showSheet) {
                ListSortPicker(sorting: $sorting, media: media)
            }
        }
    }
}
