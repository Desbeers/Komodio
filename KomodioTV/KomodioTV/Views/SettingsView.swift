//
//  SettingsView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 29/04/2022.
//

import SwiftUI
import SwiftlyKodiAPI
import Nuke

struct SettingsView: View {
    var body: some View {
        HStack(alignment: .top) {
            ViewForm()
                .frame(width: 900)
            Divider()
            VStack {
                Text("Maintanance")
                    .font(.title2)
                Button(action: {
                    Task {
                        await KodiConnector.shared.reloadHost()
                    }
                }, label: {
                    Text("Reload library")
                })
                Button(action: {
                    Nuke.ImageCache.shared.removeAll()
                    Nuke.DataLoader.sharedUrlCache.removeAllCachedResponses()
                }, label: {
                    Text("Remove image cache")
                })
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
        /// The View
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
//                Section {
//                    Button("Save") {
//                        ///
//                    }
//                    .disabled(!validateForm(host: values))
//                    .buttonStyle(.card)
//                }
            }
            
            Button(action: {
                //
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
        /// - Returns: A ``Text`` view
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
