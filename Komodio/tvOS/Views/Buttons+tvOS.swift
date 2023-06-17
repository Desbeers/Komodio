//
//  Buttons+tvOS.swift
//  Komodio (tvOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension Buttons {

    // MARK: Play Button

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

    // MARK: Resume Button

    /// The 'resume' button
    struct Resume: View {
        /// The `KodiItem` to resume
        var item: any KodiItem
        /// Bool if the player will be presented
        @State private var isPresented = false
        /// Calculate the resume time
        private var resume: Int {
            Int(item.resume.total - item.resume.position)
        }

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
                        Text("\(Utils.secondsToTimeString(seconds: resume)) to go")
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
}
