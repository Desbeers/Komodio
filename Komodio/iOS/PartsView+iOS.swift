//
//  PartsView+iOS.swift
//  Komodio (iOS)
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

extension PartsView {
    
    /// View the Ttitle and optional subtitle of the page
    struct TitleHeader: View {
        
        @State var isVisible = true
        
        @EnvironmentObject var router: Router
        
        /// The View
        var body: some View {
            Group {
           
                if isVisible {
                    HStack(alignment: .center) {

                    Button(action: {
                        router.pop()
                    },
                           label: {
                        Image(systemName: "chevron.backward.square.fill")
                            .foregroundColor(.accentColor)
                    })
                    .disabled(router.routes.count == 1)
                    .help("Go back")
                    .font(.title)
                    .buttonStyle(.plain)
                    VStack(alignment: .leading) {
                        
                        //if let subtitle = router.subtitle {
                        Text(router.subtitle ?? "Komodio")
                            .padding(.leading, 2)
                            .font(.subheadline)
                        //.transition(.opacity)
                        //.transition(AnyTransition.opacity.combined(with: .slide))
                        //}
                        Text(router.title)
                            .font(router.subtitle == nil ? .title : .title)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                    .padding(.top)
                    .padding()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial)
                    .ignoresSafeArea()
                    .transition(AnyTransition.opacity.combined(with: .slide))
            }
            }
            .onChange(of: router.routes) { _ in
                if (router.currentRoute.isPlayer) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.isVisible = false
                    }
                } else {
                    self.isVisible = true
                }
            }
//            .gesture(
//                DragGesture()
//                    .onChanged {
//                        if $0.startLocation.x < $0.location.x {
//                            logger("DRAG!!")
//                            router.pop()
//                        }
//            })
            .animation(.default, value: isVisible)
//            .padding(.top)
//            .padding()
//            .frame(height: 100)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(.thinMaterial)
//            .ignoresSafeArea()
        }
        
    }
}

