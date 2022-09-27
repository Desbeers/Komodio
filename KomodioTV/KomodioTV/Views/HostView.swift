//
//  HostView.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 25/09/2022.
//

import SwiftUI
import SwiftlyKodiAPI

/// A form to edit a host
struct HostView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The host we want to edit
    //let host: HostItem = HostItem()
    /// The AppState
    @EnvironmentObject var appState: AppState
    /// The values of the form
    @State var values = HostItem()
    /// The body of this View
    var body: some View {
        VStack {
            Form {
                //Section(footer: footer(text: "Kodi's that are available")) {
                    ForEach(kodi.bonjourHosts, id: \.ip) { host in
                        
                        Button(action: {
                            values.description = host.name
                            values.ip = host.ip
                            appState.selectedTab = .home
                            AppState.saveHost(host: values)
                        }, label: {
                            Text(host.name)
                        })
                        .disabled(AppState.shared.host?.ip == host.ip)
                    }
                //}
                //.focusable()
                
//                Section(footer: footer(text: "The TCP and UDP ports")) {
//                    HStack(spacing: 10) {
//                        TextField("8080", text: $values.port, prompt: Text("TCP port"))
//                        //.frame(width: 105)
//
//                        Divider()
//
//                        TextField("9090", text: $values.tcp, prompt: Text("UDP port"))
//                        //.frame(width: 105)
//                    }
//                }
//                Section(footer: footer(text: "Your username and password")) {
//                    HStack(spacing: 10) {
//                        TextField("username", text: $values.username, prompt: Text("Your username"))
//                        //.frame(width: 105)
//
//                        Divider()
//
//                        TextField("password", text: $values.password, prompt: Text("Your password"))
//                        //.frame(width: 105)
//                    }
//                }
            }
            
//            Button(action: {
//                AppState.saveHost(host: values)
//            }, label: {
//                Text("Save")
//            })
//            .disabled(!validateForm(host: values))
//            //.buttonStyle(.card)
        }
        .padding()
        .task {
            /// Fill the form if we already have a host
            if let values = AppState.getHost() {
                self.values = values
            }
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
