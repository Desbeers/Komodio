//
//  SettingsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 29/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct SettingsView: View {
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text("Maintanance")
                    .font(.title2)
                Form {
                    Button(action: {
                        Task {
                            appState.selectedTab = .home
                            await KodiConnector.shared.loadLibrary(cache: false)
                        }
                    }, label: {
                        Text("Reload library")
                    })
                    .disabled(kodi.state != .loadedLibrary)
                }
            }
            Divider()
            VStack {
                Text("Your Kodi host")
                    .font(.title2)
                if kodi.bonjourHosts.isEmpty {
                    Text("There are no Kodi's online")
                }
                HostView()
                    .frame(width: 900)
            }
        }
    }
}

extension SettingsView {
    
    /// A form to edit a host
    struct ViewForm: View {
        /// The host we want to edit
        let host: HostItem = HostItem()
        /// The values of the form
        @State var values = HostItem()
        /// The body of this View
        var body: some View {
            VStack {
            Text("Your Kodi host")
                    .font(.title2)
            Form {
                Section(footer: footer(text: "The IP address of your Kodi")) {
                    TextField("127.0.0.1", text: $values.ip, prompt: Text("The IP address of your Kodi"))
                        //.frame(width: 220)
                }
                Section(footer: footer(text: "The TCP and UDP ports")) {
                    HStack(spacing: 10) {
                        TextField("8080", text: $values.port, prompt: Text("8080"))
                            //.frame(width: 105)

                        Divider()

                        TextField("9090", text: $values.tcp, prompt: Text("9090"))
                            //.frame(width: 105)
                    }
                }
                Section(footer: footer(text: "Your username and password")) {
                    HStack(spacing: 10) {
                        TextField("username", text: $values.username, prompt: Text("Your username"))
                            //.frame(width: 105)

                        Divider()

                        TextField("password", text: $values.password, prompt: Text("Your password"))
                            //.frame(width: 105)
                    }
                }
            }
            
            Button(action: {
                AppState.saveHost(host: values)
            }, label: {
                Text("Save")
            })
            .disabled(!validateForm(host: values))
            //.buttonStyle(.card)
        }
            .padding()
            .task {
                /// Fill the form
                values = host
            }
        }
        /// The text underneath a form item
        /// - Parameter text: The text to display
        /// - Returns: A `Text` View
        func footer(text: String) -> some View {
            Text(text)
                .font(.caption)
                .padding(.bottom, 6)
        }
        /// Validate the form with the HostItem
        /// - Parameter host: The ``HostItem`` currenly editing
        /// - Returns: True or false
        private func validateForm(host: HostItem) -> Bool {
            var status = true
            if !isValidIP(address: host.ip) {
                status = false
            }
            return status
        }
        /// Validate the IP address in the form with the HostItem
        /// - Parameter address: The IP address
        /// - Returns: True or false
        private func isValidIP(address: String) -> Bool {
            let parts = address.components(separatedBy: ".")
            let nums = parts.compactMap { Int($0) }
            return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
        }
    }
}
