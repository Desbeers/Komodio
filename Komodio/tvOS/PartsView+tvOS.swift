//
//  PartsView+tvOS.swift
//  Komodio (tvOS)
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

extension PartsView {
    
    /// Show the optional title and subtitle on a View
    ///
    /// - Note: We can't control the page animations on tvOS, so we just hide
    /// this view as soon as a new header is set. Ugly, but else the header for the next
    /// View is shown before the previous View is gone.
    struct TitleHeader: View {
//        /// The AppState model
//        @EnvironmentObject var appState: AppState
        
        @Binding var router: [Route]
        
        /// Visible or not
        @State var visible: Bool = true
        /// The View
        var body: some View {
            VStack(alignment: .leading) {
                if let subtitle = router.dropLast().last?.title {
                    Text(visible ? subtitle : "")
                        .padding(.leading, 2)
                        .font(.subheadline)
                } else {
                    Text(" ")
                }
                if let title = router.last?.title {
                //if let title = appState.filter.title {
                Text(visible ? title : "")
                        .font(.title)
                }
            }
            //.animation(.default, value: appState.filter)
            .padding(.leading, 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 160)
            .background(.ultraThinMaterial)
//            .onChange(of: router.title) { _ in
//                print("Header filter changed!")
//                visible.toggle()
//            }
        }
    }
}
