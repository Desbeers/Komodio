//
//  RootView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//

import SwiftUI
import SwiftUIRouter

extension RootView {
    
    struct RootViewModifier: ViewModifier {
        
        @Binding var selected: String?
        
        var navigator: Navigator
        
        /// The view
        func body(content: Content) -> some View {
            content
                .onChange(of: selected) { newSelected in
                    let pathComponents = navigator.path.components(separatedBy: "/").dropFirst()
                    if newSelected != pathComponents.first {
                        navigator.navigate("/" + (newSelected ?? ""))
                    }
                }
                .onChange(of: navigator.path) { newPath in
                    let components = newPath.components(separatedBy: "/").dropFirst()
                    if selected != components.first {
                        selected = components.first
                    }
                }
        }
    }
}
