//
//  Extensions+macOS.swift
//  Komodio
//
//  Created by Nick Berendsen on 27/02/2022.
//

import SwiftUI

extension View {
    
    /// Open a View in a new window
    /// - Parameters:
    ///   - title: The title of the window as String
    ///   - size: The size of the window as ``NSSize``
    /// - Returns: An ``NSWindow``
    @discardableResult func openInWindow(title: String, size: NSSize) -> NSWindow {
        let controller = NSHostingController(rootView: self.frame(minWidth: size.width, minHeight: size.height))
        let window = NSWindow(contentViewController: controller)
        window.contentViewController = controller
        window.title = title
        // window.toggleFullScreen(true)
        window.makeKeyAndOrderFront(self)
        return window
    }
}

extension NSTableView {
    /// Remove the white background from Lists on macOS
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        backgroundColor = NSColor.clear
        enclosingScrollView?.drawsBackground = false
        allowsColumnReordering = true
    }
}
