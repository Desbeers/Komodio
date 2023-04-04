//
//  Pickers.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Pickers

/// Collection of SwiftUI Pickers (shared)
enum Pickers {
    // Just a namespace here
}

extension Pickers {

    // MARK: List Sort Picker

    /// Sort a list: Two pickers to select the method and order
    ///
    /// For `tvOS` it will be Buttons for the method instead of a picker because it might be too many items
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
                            .fontWeight(sorting.method == method ? .heavy : .regular)
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
                if let index = scene.listSortSettings.firstIndex(where: { $0.id == sorting.id }) {
                    scene.listSortSettings[index] = item
                } else {
                    scene.listSortSettings.append(item)
                }
                SceneState.saveListSortSettings(settings: scene.listSortSettings)
            }
            .labelsHidden()
        }
    }

    // MARK: List Sort Sheet

    /// SwiftUI Button to show the ``Pickers/ListSortPicker`` in a Sheet
    /// - Note: Used for tvOS or else the UI will be too cluttered
    struct ListSortSheet: View {
        /// The color scheme
        @Environment(\.colorScheme) var colorScheme
        /// The current sorting
        @Binding var sorting: SwiftlyKodiAPI.List.Sort
        /// The kind of media
        let media: Library.Media
        /// Bool to show the Sheet
        @State private var showSheet: Bool = false

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                showSheet = true
            }, label: {
                Label(title: {
                    Text("\(sorting.method.displayLabel) ∙ \(sorting.order.displayLabel(method: sorting.method))")
                }, icon: {
                    Image(systemName: "arrow.up.arrow.down")
                })
            })
            .padding(.trailing)
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text("\(sorting.method.displayLabel) ∙ \(sorting.order.displayLabel(method: sorting.method))")
                        .padding()
                        .font(.title)
                    ListSortPicker(sorting: $sorting, media: media)
                }
                .animation(.default, value: sorting)
            }
        }
    }
}

extension Pickers {

    // MARK: Rating Widget

    /// Picker for User Rating of a `KodiItem`
    ///
    /// For `tvOS` it will be Buttons instead of a picker because a Picker applies the selection directly
    struct RatingWidget: View {
        /// The KodiItem
        let item: any KodiItem
        /// The rating of the ityem
        @State private var rating: Int = 0
        /// The presentation mode  (tvOS)
        @Environment(\.presentationMode) var presentationMode

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            HStack {
#if os(macOS)
                Picker(selection: $rating, label: Text("Your rating:")) {
                    Image(systemName: "nosign")
                        .tag(0)
                    ForEach(1..<11, id: \.self) { number in
                        Image(systemName: number <= rating ? "star.fill" : "star")
                            .foregroundColor(number <= rating ? .yellow : .secondary.opacity(0.4))
                            .tag(number)
                    }
                }
                .pickerStyle(.segmented)
#endif

#if os(tvOS)
                Button(action: {
                    rating = 0
                }, label: {
                    Image(systemName: "nosign")
                        .foregroundColor(.secondary)
                })
                ForEach(1..<11, id: \.self) { number in
                    Button(action: {
                        rating = number
                    }, label: {
                        Image(systemName: number <= rating ? "star.fill" : "star")
                            .foregroundColor(number <= rating ? .yellow : .secondary.opacity(0.4))
                    })
                }
#endif
            }
            .task {
                rating = item.userRating
            }
            .onChange(of: rating) { newRating in
                if newRating != item.userRating {
                    Task {
                        await item.setUserRating(rating: rating)
                        #if os(tvOS)
                        /// The rating is shown in a Sheet; close it when the value has changed
                        presentationMode.wrappedValue.dismiss()
                        #endif
                    }
                }
            }
        }
    }

    // MARK: Rating Widget Sheet

    /// SwiftUI Button to show the ``Pickers/ListSortPicker`` in a Sheet
    /// - Note: Used for tvOS or else the UI will be too cluttered
    struct RatingWidgetSheet: View {
        /// The KodiItem
        let item: any KodiItem
        /// Bool to show the sSheet
        @State private var showSheet: Bool = false

        // MARK: Body of the View

        /// The body of the View

        var body: some View {
            Button(action: {
                showSheet = true
            }, label: {
                Label(title: {
                    PartsView.ratingToStars(rating: item.userRating)
                }, icon: {
                    Image(systemName: "star.circle.fill")
                })
            })
            .sheet(isPresented: $showSheet) {
                VStack {
                    Text(item.title)
                        .padding()
                        .font(.title)
                    Text("Your rating")
                        .padding()
                        .font(.title3)
                        .foregroundColor(.secondary)
                    RatingWidget(item: item)
                        .scaleEffect(0.8)
                        .padding()
                }
                .background {
                    KodiArt.Fanart(item: item)
                        .scaledToFill()
                        .opacity(0.2)
                }
            }
        }
    }
}
