//
//  MacCommands.swift
//  Komodio (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// A `Command` to show a GitHub link as help
public struct GithubHelpCommand: Commands {
    public init(url: String, replace: Bool = true) {
        self.url = url
        self.replace = replace
    }
    private let url: String
    private let replace: Bool
    public var body: some Commands {
        switch replace {
        case true:
            CommandGroup(replacing: .help) {
                Link(destination: link) {
                    Text("\(Bundle.main.displayName) on GitHub")
                }
            }
        case false:
            CommandGroup(after: .help) {
                Link(destination: link) {
                    Text("Source Code on GitHub")
                }
            }
        }
    }
    private var link: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: url)!
    }
}

/// A `Command` to customise the 'About' Window
public struct AboutPanelCommand: Commands {

    public init(
        title: String,
        applicationName: String = Bundle.main.displayName,
        credits: String? = nil
    ) {
        let options: [NSApplication.AboutPanelOptionKey: Any]
        if let credits {
            options = [
                .applicationName: applicationName,
                .credits: NSAttributedString(
                    string: "\n\(credits)\n",
                    attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
                    ]
                )
            ]
        } else {
            options = [.applicationName: applicationName]
        }
        self.init(title: title, options: options)
    }

    public init(
        title: String,
        options: [NSApplication.AboutPanelOptionKey: Any]
    ) {
        self.title = title
        self.options = options
    }

    private let title: String
    private let options: [NSApplication.AboutPanelOptionKey: Any]

    public var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button(title) {
                NSApplication.shared
                    .orderFrontStandardAboutPanel(options: options)
            }
        }
    }
}

public extension Bundle {

    var displayName: String {
        infoDictionary?["CFBundleDisplayName"] as? String ?? infoDictionary?["CFBundleName"] as? String ?? "-"
    }
}
