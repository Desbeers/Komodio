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

    // MARK: Rating Widget

    /// Picker for User Rating of a `KodiItem`
    struct RatingWidget: View {
        /// The KodiItem
        let item: any KodiItem
        /// The rating of the ityem
        @State private var rating: Int = 0

        // MARK: Body of the View

        /// The body of the `View`
        var body: some View {
            Picker(selection: $rating, label: Text("Your rating:")) {
                Label("No Rating", systemImage: "nosign")
                    .tag(0)
                ForEach(1..<11, id: \.self) { number in
#if os(tvOS)
                    Label(String(repeating: "★", count: number), systemImage: "\(number).circle")
                        .tag(number)
#else
                    Image(systemName: number <= rating ? "star.fill" : "star")
                        .foregroundColor(number <= rating ? .yellow : .secondary.opacity(0.4))
                        .tag(number)
#endif
                }
            }
#if os(macOS) || os(iOS) || os(visionOS)
            .pickerStyle(.segmented)
            .labelsHidden()
#endif
            .task {
                rating = item.userRating
            }
            .onChange(of: rating) {
                if rating != item.userRating {
                    Task {
                        await item.setUserRating(rating: rating)
                    }
                }
            }
        }
    }

    // MARK: Rating Widget Sheet

    /// SwiftUI Button to show the ``RatingWidget`` in a Menu
    /// - Note: Used for tvOS or else the UI will be too cluttered
    struct RatingWidgetMenu: View {
        /// The KodiItem
        let item: any KodiItem

        // MARK: Body of the View

        /// The body of the `View`

        var body: some View {
            Menu(content: {
                RatingWidget(item: item)
            }, label: {
                Label(title: {
                    PartsView.ratingToStars(rating: item.userRating)
                }, icon: {
                    Image(systemName: "star.circle.fill")
                })
            })
        }
    }
}
