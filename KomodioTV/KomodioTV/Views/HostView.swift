//
//  HostView.swift
//  KomodioTV
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// The 'Host' SwiftUI View
struct HostView: View {
    /// The AppState model
    @EnvironmentObject var appState: AppState
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The values of the form
    @State var values = HostItem()
    /// The body of this View
    var body: some View {
        VStack {
            Form {
                ForEach(kodi.bonjourHosts, id: \.ip) { host in
                    Button(action: {
                        values.ip = host.ip
                        appState.selectedTab = .home
                        AppState.saveHost(host: values)
                    }, label: {
                        Text(host.name)
                    })
                    .disabled(AppState.shared.host?.ip == host.ip)
                }
            }
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
