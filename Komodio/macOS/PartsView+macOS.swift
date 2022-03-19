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
                if router.routes.count > 1 {
                    Button(action: {
                        router.pop()
                    },
                           label: {
                        Image(systemName: "chevron.backward.square.fill")
                    })
                    .keyboardShortcut(.cancelAction)
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
                .frame(width: 400, alignment: .leading)
                Spacer()
                Divider()
                HStack {
                    ForEach(Route.menuItems, id: \.self) { item in
                        RouterLink(item: item) {
                            Label(item.title, systemImage: item.symbol)
                                .labelStyle(LabelStyles.MenuItem())
                                .padding()
                        }
                    }
                }
                .buttonStyle(.plain)
            }
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
