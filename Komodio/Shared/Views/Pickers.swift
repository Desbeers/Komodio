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
    ///
    /// For `tvOS` it will be Buttons instead of a picker because it might be too many items
    struct ListSortPicker: View {
        /// The current sorting
        @Binding var sorting: SwiftlyKodiAPI.List.Sort
        /// The kind of media
        let media: Library.Media
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            VStack {
#if os(macOS)
                Picker(selection: $sorting.method, label: Text("Sort method")) {
                    ForEach(SwiftlyKodiAPI.List.Sort.getMethods(media: media), id: \.rawValue) { method in
                        Text(method.displayLabel)
                            .tag(method)
                    }
                }
#endif
#if os(tvOS)
                ForEach(SwiftlyKodiAPI.List.Sort.getMethods(media: media), id: \.rawValue) { method in
                    Button(action: {
                        sorting.method = method
                    }, label: {
                        Text(method.displayLabel)
                            .frame(width: 600)
                    })
                }
#endif
                Picker(selection: $sorting.order, label: Text("Sort order")) {
                    ForEach(SwiftlyKodiAPI.List.Sort.Order.allCases, id: \.rawValue) { order in
                        Text(order.displayLabel(method: sorting.method))
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
                SceneState.saveListSortSettings(settings: scene.listSortSettings)
            }
            .labelsHidden()
        }
    }

    /// SwiftUI Button to show the ``Pickers/ListSortPicker`` in a Sheet
    /// - Note: Used for tvOS or else the UI will be too cluttered
    struct ListSortSheet: View {
        /// The current sorting
        @Binding var sorting: SwiftlyKodiAPI.List.Sort
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
                    Text("\(sorting.method.displayLabel) ∙ \(sorting.order.displayLabel(method: sorting.method))")
                        .padding()
                }, icon: {
                    Image(systemName: "arrow.up.arrow.down")
                        .padding(.leading)
                })
            })
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text("\(sorting.method.displayLabel) ∙ \(sorting.order.displayLabel(method: sorting.method))")
                        .padding()
                        .font(.title)
                    ListSortPicker(sorting: $sorting, media: media)
                }
            }
        }
    }
}
