//
//  AppDelegate.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

#if os(macOS)

@Observable class AppDelegate: NSObject, NSApplicationDelegate {
    /// Bool if the main window is in fulll screen
    var fullScreen: Bool = false
    /// Check the full screen toggle
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApp.windows.first {
            fullScreen = window.styleMask.contains(.fullScreen)
        }
        NotificationCenter.default.addObserver(
            forName: NSWindow.willEnterFullScreenNotification,
            object: nil,
            queue: OperationQueue.main
        ) { _ in
            if let window = NSApp.mainWindow, window.title == "Komodio" {
                print("Entered Fullscreen")
                self.fullScreen = true
            }
        }
        NotificationCenter.default.addObserver(
            forName: NSWindow.willExitFullScreenNotification,
            object: nil,
            queue: OperationQueue.main
        ) { _ in
            if let window = NSApp.mainWindow, window.title == "Komodio" {
                print("Exited Fullscreen")
                self.fullScreen = false
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        /// Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        /// Don't quit the application when we close the window
        false
    }
}
#endif
