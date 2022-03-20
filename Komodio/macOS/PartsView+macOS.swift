//
//  PartsView+macOS.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

extension PartsView {
    
    /// View the title and optional subtitle of the page
    struct TitleHeader: View {
        
        @EnvironmentObject var router: Router
        
        /// The View
        var body: some View {
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                if router.routes.count > 1 {
                    Button(action: {
                        router.pop()
                    },
                           label: {
                        Image(systemName: "chevron.backward")
                    })
                    .keyboardShortcut(.cancelAction)
                    .help("Go back")
                    //.font(.title)
                    .buttonStyle(.plain)
                    .padding(.trailing)
                    //.padding(.top)
                }
                //HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text(router.subtitle ?? "Komodio")
                    .opacity(0.5)
                        .padding(.trailing)
                        //.background(.green)
                        //.font(.headline)
                //Image(systemName: "arrow.forward")
                    Text(router.title)
                        
            }
            .font(.title)
            .animation(.default, value: router.title)
            .padding(.top)
            .padding()
            .frame(height: 80)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .ignoresSafeArea()
        }
        
    }
}
