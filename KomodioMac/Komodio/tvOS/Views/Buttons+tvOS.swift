//
//  Buttons+tvOS.swift
//  Komodio
//
//  Created by Nick Berendsen on 24/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

extension Buttons {

    /// The 'play' button
    struct Play: View {
        var item: any KodiItem
        @State private var isPresented = false
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
                .padding()
            })
            .buttonStyle(.card)
            .fullScreenCover(isPresented: $isPresented) {
                KodiPlayerView(video: item)
            }
        }
    }

    /// The 'resume' button
    struct Resume: View {
        var item: any KodiItem
        @State private var isPresented = false
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
                .padding()
            })
            .buttonStyle(.card)
            .fullScreenCover(isPresented: $isPresented) {
                KodiPlayerView(video: item, resume: true)
            }
        }
    }

    /// The 'played state' button
    struct PlayedState: View {
        var item: any KodiItem
        var body: some View {
            Button(action: {
                Task {
                    await item.togglePlayedState()
                }
            }, label: {
                Text(item.playcount == 0 ? "Mark as watched" : "Mark as new")
                    .padding()
            })
            .buttonStyle(.card)
        }
    }
}
