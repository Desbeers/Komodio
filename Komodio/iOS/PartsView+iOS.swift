//
//  PartsView+iOS.swift
//  Komodio (iOS)
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI

import SwiftlyKodiAPI

extension PartsView {
    
    /// View the title and optional subtitle of the page
    struct TitleHeader: View {
        
        @EnvironmentObject var router: Router
        
        /// The View
        var body: some View {
            HStack(alignment: .center) {
                if router.routes.count > 1 {
                Button(action: {
                    router.pop()
                },
                       label: {
                    Image(systemName: "chevron.backward.square.fill")
                })
                //.disabled(router.routes.count == 1)
                .help("Go back")
                .font(.title)
                .buttonStyle(.plain)
                .padding(.top)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(router.subtitle ?? "Komodio")
                        .padding(.leading, 2)
                        .font(.subheadline)
                    Text(router.title)
                        .font(.title)
                }
            }
            .animation(.default, value: router.title)
            .padding()
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .ignoresSafeArea()
        }
        
    }
}

