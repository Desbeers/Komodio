//
//  KodiSettingsView.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// SwiftUI View for Kodi settings (shared)
struct KodiSettingsView: View {
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    /// The settings sections
    @State private var sections: [Setting.Details.Section] = []
    /// The optional selected section
    @State private var selectedSection: Setting.Details.Section?
    /// The optional selected section (for macOS)
    @State private var section = Setting.Details.Section(id: .unknown)

    // MARK: Body of the View

    /// The body of the View
    var body: some View {
        content
            .animation(.default, value: selectedSection)
            .task {
                sections = await Settings.getSections()
            }
            .task(id: selectedSection) {
                if let selectedSection {
                    scene.navigationSubtitle = selectedSection.label
                    section = selectedSection
                } else {
                    scene.navigationSubtitle = Router.kodiSettings.label.title
                    section.id = .unknown
                }
            }
    }

    // MARK: Content of the View

    /// The content of the View
    @ViewBuilder var content: some View {

#if os(macOS)
        ZStack {
            List(selection: $selectedSection) {
                Warning()
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .padding()
                ForEach(sections) { section in
                    VStack(alignment: .leading) {
                        Text(section.label)
                            .font(.headline)
                        Text(section.help)
                            .font(.caption)
                    }
                    .tag(section)
                }
            }
            .offset(x: selectedSection != nil ? -ContentView.columnWidth : 0, y: 0)
            Section(section: section)
                .transition(.move(edge: .leading))
                .offset(x: selectedSection != nil ? 0 : ContentView.columnWidth, y: 0)
        }
        .toolbar {
            if selectedSection != nil {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        selectedSection = nil
                        scene.details = .kodiSettings
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
                }
            }
        }
#endif

#if os(tvOS)
        List {
            ForEach(sections) { section in
                NavigationLink(value: section, label: {
                    VStack(alignment: .leading) {
                        Text(section.label)
                            .font(.headline)
                        Text(section.help)
                            .font(.caption)
                    }
                })
            }
        }
#endif
    }
}

// MARK: Extensions

extension KodiSettingsView {

    /// SwiftUI View for a section
    struct Section: View {
        /// The current section
        let section: Setting.Details.Section
        /// The SceneState model
        @EnvironmentObject private var scene: SceneState
        /// All the categories
        @State private var categories: [Setting.Details.Category] = []
        /// The optional selected category
        @State private var selectedCategory: Setting.Details.Category?

#if os(tvOS)
        /// The focus state of the selection (tvOS)
        @FocusState var isFocused: Bool
        /// The current selection (tvOS)
        @State private var selection: Int = 0
#endif

        // MARK: Body of the View

        var body: some View {
            content
                .task(id: section) {
                    selectedCategory = nil
                    if section.id != .unknown {
                        categories = await Settings.getCategories(section: section.id)
                    }
                }
                .task(id: selectedCategory) {
                    if let selectedCategory {
                        scene.details = .kodiSettingsDetails(section: section, category: selectedCategory)
                    }
                }

        }

        // MARK: Content of the View

        /// The content of the View
        @ViewBuilder var content: some View {

#if os(macOS)
            List(selection: $selectedCategory) {
                ForEach(categories) { category in
                    VStack(alignment: .leading) {
                        Text(category.label)
                            .font(.headline)
                        /// Help is optional
                        if let help = category.help {
                            Text(help)
                                .font(.caption)
                        }
                    }
                    .tag(category)
                }
            }
#endif

#if os(tvOS)
            HStack {
                VStack(alignment: .leading) {
                    ForEach(categories) { category in
                        VStack(alignment: .leading) {
                            Text(category.label)
                                .font(.headline)
                                .foregroundColor(selectedCategory == category ? Color("AccentColor") : Color.primary)
                            /// Help is optional
                            if let help = category.help {
                                Text(help)
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            .thickMaterial
                                .opacity(selectedCategory == category ? 1 : 0)
                        )
                        .cornerRadius(20)
                    }
                }
                .opacity(isFocused ? 1 : 0.6)
                .frame(width: 500)
                .frame(maxHeight: .infinity, alignment: .top)
                .focusable()
                .swipeGestures(
                    onUp: {
                        if isFocused {
                            selection = selection == 0 ? 0 : selection - 1
                        }
                    },
                    onDown: {
                        if isFocused {
                            selection = categories.count - 1 == selection ? selection : selection + 1
                        }
                    }
                )
                .focused($isFocused)
                .padding(.trailing)
                DetailView()
                    .focusSection()
                    .frame(maxWidth: .infinity)
            }
            .animation(.default, value: selectedCategory)
            .animation(.default, value: isFocused)
            .task(id: selection) {
                if !categories.isEmpty {
                    selectedCategory = categories[selection]
                }
            }
            .task(id: categories) {
                if !categories.isEmpty {
                    selectedCategory = categories[selection]
                }
            }
#endif
        }
    }
}

extension KodiSettingsView {

    /// SwiftUI View for details of a setting
    struct Details: View {
        /// The current section
        let section: Setting.Details.Section
        /// The current category
        let category: Setting.Details.Category

        // MARK: Body of the View

        var body: some View {
            ScrollView {
                Text("\(section.label) - \(category.label)")
                    .font(.largeTitle)
                ForEach(category.groups.flatMap({$0.settings})) { setting in
                    KodiSettingView(setting: setting)
                        .padding(.bottom)
                }
            }
            .padding(.horizontal)
        }
    }
}

extension KodiSettingsView {

    /// SwiftUI View for warning of Kodi settings
    struct Warning: View {

        // MARK: Body of the View

        /// The body of the View
        var body: some View {
            Label(
                title: {
                    // swiftlint:disable:next line_length
                    Text("These are the *Kodi* settings on your host, not *Komodio* settings. **Komodio** might not behave according these settings and they might not be relevant for **Komodio** at all.")
                }, icon: {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                })
        }
    }
}
