//
//  Extensions.swift
//  Komodio
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import AVKit
import SwiftlyKodiAPI

extension AVPlayer {
    
    /// Is the AV player playing or not?
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension View {
    
    /// Shortcut for macOS specific modifiers
    func macOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(macOS)
        return modifier(self)
        #else
        return self
        #endif
    }

    /// Shortcut for tvOS specific modifiers
    func tvOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(tvOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
    /// Shortcut for iOS specific modifiers
    func iOS<Content: View>(_ modifier: (Self) -> Content) -> some View {
        #if os(iOS)
        return modifier(self)
        #else
        return self
        #endif
    }
    
//    /// Shortcut for the ``WrapperViewModifier``
//    func wrapItems(
//        title: String = "",
//        subtitle: String = "",
//        fanart: String = "",
//        scrollView: Bool = true
//    ) -> some View {
//        modifier(PartsView.WrapViewModifier(title: title,
//                                            subtitle: subtitle,
//                                            fanart: fanart,
//                                            scrollView: scrollView)
//        )
//    }
    
    /// Shortcut to the ``WatchStatusViewModifier``
    func watchStatus(of item: Binding<KodiItem>) -> some View {
        modifier(PartsView.WatchStatusViewModifier(item: item))
    }
    
    /// Cheap `if` extension that should not be used because of performance
    /// - Returns: A modified View
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
