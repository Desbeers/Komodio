//
//  Buttons+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension Buttons {

    /// The 'play' button
    struct Play: View {
        /// The `KodiItem` to play
        var item: any KodiItem
        /// Bool if the player will be presented
        @State private var isPresented = false

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                Label(title: {
                    VStack(alignment: .leading) {
                        Text("Play")
                        if item.resume.position != 0 {
                            Text("From beginning")
                                .font(.system(size: 20))
                        }
                    }
                }, icon: {
                    Image(systemName: "play.fill")
                })
            })
            .fullScreenCover(isPresented: $isPresented) {
                KomodioPlayerView(video: item)
            }
        }
    }

    /// The 'resume' button
    struct Resume: View {
        /// The `KodiItem` to resume
        var item: any KodiItem
        /// Bool if the player will be presented
        @State private var isPresented = false

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Button(action: {
                withAnimation {
                    isPresented.toggle()
                }
            }, label: {
                Label(title: {
                    VStack(alignment: .leading) {
                        Text("Resume")
                        Text("\(Parts.secondsToTime(seconds: Int(item.resume.total - item.resume.position))) to go")
                            .font(.system(size: 20))
                    }
                }, icon: {
                    Image(systemName: "play.fill")
                })
            })
            .fullScreenCover(isPresented: $isPresented) {
                KomodioPlayerView(video: item, resume: true)
            }
        }
    }

//    /// The 'played state' button
//    struct PlayedState: View {
//        /// The `KodiItem` to set
//        let item: any KodiItem
//
//        // MARK: Body of the View
//
//        /// The body of the View
//        var body: some View {
//            Button(action: {
//                Task {
//                    await item.togglePlayedState()
//                }
//            }, label: {
//                Label(title: {
//                    Text(item.playcount == 0 ? "Mark \(item.media.description) as watched" : "Mark  \(item.media.description) as new")
//                }, icon: {
//                    Image(systemName: item.playcount == 0 ? "eye.fill" : "eye")
//                })
//            })
//            .labelStyle(Styles.PlayLabel())
//            .buttonStyle(Styles.PlayButton())
//        }
//    }
}
