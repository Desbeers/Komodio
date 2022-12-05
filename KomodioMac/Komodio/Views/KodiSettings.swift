//
//  KodiSettings.swift
//  Komodio
//
//  Created by Nick Berendsen on 04/12/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct KodiSettings: View {
    
    /// The SceneState model
    @EnvironmentObject var scene: SceneState
    
    @State private var sections: [Setting.Details.Section] = []
    @State private var selectedSection: Setting.Details.Section?
    var body: some View {
        ZStack {
            List(selection: $selectedSection) {
                ForEach(sections) { section in
                    VStack(alignment: .leading) {
                        Text(section.label)
                            .font(.headline)
                        Text(section.id.rawValue)
                        Text(section.help)
                            .font(.caption)
                    }
                    .tag(section)
                }
            }
            .offset(x: selectedSection != nil ? -ContentView.columnWidth : 0, y: 0)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            Section(section: $selectedSection)
                .transition(.move(edge: .leading))
                .offset(x: selectedSection != nil ? 0 : ContentView.columnWidth, y: 0)
            //.id(selectedSection)
        }
        .animation(.default, value: selectedSection)
        .task {
            sections = await Settings.getSections()
        }
        .task(id: selectedSection) {
            if let selectedSection {
                scene.navigationSubtitle = selectedSection.label
            } else {
                scene.navigationSubtitle = Router.kodiSettings.label.title
            }
        }
    }
}

extension KodiSettings {
    
    struct Section: View {
        @Binding var section: Setting.Details.Section?
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        @State private var categories: [Setting.Details.Category] = []
        @State private var selectedCategory: Setting.Details.Category?
        var body: some View {
            List(selection: $selectedCategory) {
                ForEach(categories) { categorie in
                    VStack(alignment: .leading) {
                        Text(categorie.label)
                            .font(.headline)
                        /// Help is optional
                        if let help = categorie.help {
                            Text(help)
                                .font(.caption)
                        }
                    }
                    .tag(categorie)
                }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))
            .task(id: section) {
                if let section {
                    categories = await Settings.getCategories(section: section.id)
                }
            }
            .task(id: selectedCategory) {
                if let section, let selectedCategory {
                    scene.details = .kodiSettingsDetails(section: section.id, category: selectedCategory.id)
                }
            }
            .toolbar {
                if section != nil {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            section = nil
                            selectedCategory = nil
                            scene.details = .kodiSettings
                        }, label: {
                            Image(systemName: "chevron.backward")
                        })
                    }
                }
            }
        }
    }
}
extension KodiSettings {
    struct Details: View {
        let section: Setting.Section
        let category: Setting.Category
        @State private var settings: [Setting.Details.Base] = []
        var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(settings.filter({$0.parent == .unknown})) { setting in
                        KodiSetting(setting: setting)
                            .padding(.bottom)
                    }
                }
                .padding()
            }
            .task(id: category) {
                settings = await Settings.getSettings(section: section, category: category)
            }
        }
    }
}

extension KodiSettings {
    
    /// The View for a Kodi Setting
    struct KodiSetting: View {
//        /// The AppState model
//        @EnvironmentObject var appState: AppState
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector

        
        /// The Kodi setting
        @State var setting: Setting.Details.Base
        
        @State private var valueString: String = ""
        /// The View
        var body: some View {
            VStack(alignment: .leading) {
                let _ = Self._printChanges()
                switch setting.control.controlType {
                case .list:
                    Text(setting.label)
                        .font(setting.parent == .unknown ? .title2 : .headline)
                    Picker(setting.label, selection: $setting.valueInt) {
                        ForEach(setting.settingInt ?? [Setting.Details.SettingInt](), id: \.self) { option in
                            Text(option.label)
                                .tag(option.value)
                        }
                    }
                    .labelsHidden()
                    //.disabled(KodioSettings.disabled(setting: setting.id))
                case .spinner:
                    Text(setting.label)
                        .font(setting.parent == .unknown ? .title2 : .headline)
                    Picker(setting.label, selection: $setting.valueInt) {
                        
                        ForEach((setting.minimum...setting.maximum), id: \.self) { value in
                            
                            Text(value == 0 ? setting.control.minimumLabel : formatLabel(value: value))
                                .tag(value)
                        }
                        
                        ForEach(setting.settingInt ?? [Setting.Details.SettingInt](), id: \.self) { option in
                            Text(option.label)
                                .tag(option.value)
                        }
                    }
                    .labelsHidden()
                    //.disabled(KodioSettings.disabled(setting: setting.id))
                case .toggle:
                    Toggle(setting.label, isOn: $setting.valueBool)
                    //.disabled(KodioSettings.disabled(setting: setting.id))
                case .edit:
                    TextField(setting.label, text: $valueString)
                default:
                    Text("Setting \(setting.control.controlType.rawValue) is not implemented")
                        .font(.caption)
                }
                
                Text(setting.help)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
                //                Text(KodioSettings.disabled(setting: setting.id) ? "Kodio takes care of this setting" : "")
                //                    .font(.caption)
                //                    .foregroundColor(.red)
                /// Recursive load child settings
                ForEach(kodi.settings.filter({$0.parent == setting.id && $0.enabled})) { child in
                    KodiSetting(setting: child)
                        .padding(.top)
                }
            }
            .task(id: setting) {
                valueString = setting.valueString
            }
            .padding(setting.parent == .unknown ? .all : .horizontal)
            .background(.thickMaterial)
            .cornerRadius(10)
            //.animation(.default, value: appState.settings)
            .onChange(of: setting.valueInt) { _ in
                Task { @MainActor in
                    print("valueInt")
                    await Settings.setSettingValue(setting: setting.id, int: setting.valueInt)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings()
                }
            }
            .onChange(of: setting.valueBool) { _ in
                Task { @MainActor in
                    print("valueBool")
                    await Settings.setSettingValue(setting: setting.id, bool: setting.valueBool)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings()
                }
            }
            .onChange(of: valueString) { _ in
                Task { @MainActor in
                    print("valueString")
                    await Settings.setSettingValue(setting: setting.id, string: valueString)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings()
                }
            }
        }
        
        func formatLabel(value: Int) -> String {
            // swiftlint:disable:next colon
            let labelRegex = /{0:d}(?<label>.+?)/
            if let result = setting.control.formatLabel.wholeMatch(of: labelRegex) {
                return "\(value)\(result.label)"
            } else {
                return "\(value)"
            }
            
        }
    }
    
}
