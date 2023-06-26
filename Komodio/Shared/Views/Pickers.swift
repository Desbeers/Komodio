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
                    KodiListSort.PickerView(sorting: $sorting, media: media)
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

#if os(iOS)
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
