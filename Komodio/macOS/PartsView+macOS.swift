//
//  PartsView+macOS.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

extension PartsView {
    
    /// View the Ttitle and optional subtitle of the page
    struct TitleHeader: View {
        /// The AppState model
        @EnvironmentObject var appState: AppState
        /// The Navigator model
        @EnvironmentObject var navigator: Navigator
        /// The View
        var body: some View {
            HStack(alignment: .center) {
                Button(action: { navigator.goBack() }) {
                    Image(systemName: "chevron.backward.square.fill")
                        .foregroundColor(navigator.canGoBack ? .accentColor : .secondary)
                }
                .disabled(!navigator.canGoBack)
                .help("Go back")
                .font(.title)
                .buttonStyle(.plain)
                VStack(alignment: .leading) {
                    if let subtitle = appState.filter.subtitle {
                        Text(subtitle)
                            .padding(.leading, 2)
                            .font(.subheadline)
                            .transition(AnyTransition.opacity.combined(with: .slide))
                    }
                    Text(appState.filter.title ?? "Komodio")
                        .font(appState.filter.subtitle == nil ? .title : .title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(navigator.path)
            }
            .animation(.default, value: appState.filter)
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .ignoresSafeArea()
        }
        
    }
}
