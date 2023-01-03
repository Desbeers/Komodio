//
//  KodiSettingsView.swift
//  Komodio
//
//  Created by Nick Berendsen on 04/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct KodiSettingsView: View {

    /// The SceneState model
    @EnvironmentObject var scene: SceneState

    @State private var sections: [Setting.Details.Section] = []
    @State private var selectedSection: Setting.Details.Section?

    /// The optional selected section (macOS)
    @State private var section = Setting.Details.Section(id: .unknown)

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
#if os(macOS)
    /// The content of the View
    var content: some View {
        ZStack {
            List(selection: $selectedSection) {
                // swiftlint:disable:next line_length
                Label("These are the *Kodi* settings on your host, not *Komodio* settings. **Komodio** might or might not behave according these preferences and they might not be relevant here at all", systemImage: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
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
            .listStyle(.inset(alternatesRowBackgrounds: true))
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
    }
#endif
#if os(tvOS)
    /// The content of the View
    var content: some View {
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
    }
#endif
}

extension KodiSettingsView {

    struct Section: View {
        let section: Setting.Details.Section
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        @State private var categories: [Setting.Details.Category] = []
        @State private var selectedCategory: Setting.Details.Category?

#if os(tvOS)

        /// The focus state of the selection (tvOS)
        @FocusState var isFocused: Bool

        @State private var selection: Int = 0

#endif
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
#if os(macOS)
        /// The content of the View
        var content: some View {
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
            .listStyle(.inset(alternatesRowBackgrounds: true))
        }
#endif
#if os(tvOS)
        /// The content of the View
        var content: some View {
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
                .background(.ultraThinMaterial.opacity(0.8))
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
        }
#endif
    }
}

extension KodiSettingsView {
    struct Details: View {
        let section: Setting.Details.Section
        let category: Setting.Details.Category
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
