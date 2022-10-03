//
//  PartsView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// A collection of bits ad pieces uses elsewhere
enum PartsView {
    /// Just a namespace
}

// MARK: Watch Toggle

extension PartsView {
    
    /// A Button to toggle the watched status of a Kodi item
    /// - Note: Don't add a buttonstyle, else it will not work as context menu
    struct WatchedToggle: View {
        /// The item we want to toggle
        let item: any KodiItem
        /// The body of this View
        var body: some View {
            Button(action: {
                Task {
                    await item.togglePlayedState()
                }
            }, label: {
                /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                Label(item.playcount == 0 ? "Mark as watched" : "Mark as new", systemImage: item.playcount == 0 ? "eye.fill" : "eye")
                    .labelStyle(LabelStyles.DetailsButton())
            })
        }
    }
    
    /// A Button to toggle the resume status of a Kodi item
    /// - Note: Don't add a buttonstyle, else it will not work as context menu
    struct ResumeToggle: View {
        /// The item we want to toggle
        let item: any KodiItem
        /// The body of this View
        var body: some View {
            VStack {
                Button(action: {
                    Task {
                        await item.markAsPlayed()
                    }
                }, label: {
                    /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                    Label("Mark as watched", systemImage: "eye.fill")
                        .labelStyle(LabelStyles.DetailsButton())
                })
                Button(action: {
                    Task {
                        await item.setResumeTime(time: 0)
                    }
                }, label: {
                    /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                    Label("Start again", systemImage: "eye")
                        .labelStyle(LabelStyles.DetailsButton())
                })
            }
        }
    }
    
    /// A Button to toggle the watched state of a movie set
    /// - Note: Don't add a buttonstyle, else it will not work as context menu
    struct MovieSetToggle: View {
        /// The set we want to toggle
        let set: Video.Details.MovieSet
        /// The body of this View
        var body: some View {
            VStack {
                Button(action: {
                    Task {
                        await set.markAsPlayed()
                    }
                }, label: {
                    /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                    Label("Mark all movies as watched", systemImage: "eye.fill")
                        .labelStyle(LabelStyles.DetailsButton())
                })
                Button(action: {
                    Task {
                        await set.markAsNew()
                    }
                }, label: {
                    /// - Note: below will only render as Text in the Context Menu but as a full Label for a 'normal' button
                    Label("Mark all movies as new", systemImage: "eye")
                        .labelStyle(LabelStyles.DetailsButton())
                })
            }
        }
    }
}
