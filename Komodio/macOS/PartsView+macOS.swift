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
            HStack(alignment: .center) {
                
                Button(action: {
                    router.pop()
                },
                       label: {
                    Image(systemName: "chevron.backward.square.fill")
                })
                    .disabled(router.routes.count == 1)
                    .help("Go back")
                    .font(.title)
                    .buttonStyle(.plain)
                VStack(alignment: .leading) {
                    
                    if let subtitle = router.subtitle {
                        Text(subtitle)
                            .padding(.leading, 2)
                            .font(.subheadline)
                            .transition(AnyTransition.opacity.combined(with: .slide))
                    }
                    Text(router.title)
                        .font(router.subtitle == nil ? .title : .title)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .animation(.default, value: router.routes)
            //.padding(.top)
            //.padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .ignoresSafeArea()
        }

    }
}
