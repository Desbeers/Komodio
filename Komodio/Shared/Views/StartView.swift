//
//  StartView.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

// MARK: Start View

/// SwiftUI `View` when starting Komodio (shared)
struct StartView: View {
    /// The KodiConnector model
    @Environment(KodiConnector.self) private var kodi
    /// The SceneState model
    @Environment(SceneState.self) private var scene
    /// The loading status of the `View`
    @State private var status: ViewStatus = .loading

    // MARK: Body of the View

    /// The body of the `View`

    var body: some View {
        VStack {
#if os(macOS)
            DetailView.Wrapper(
                scroll: nil,
                part: false,
                title: kodi.host.name,
                subtitle: kodi.status.message
            ) {
                content
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    scene.navigationStack.append(.appSettings)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                        .padding(5)
                }
                .padding(35)
                .buttonStyle(.borderedProminent)
            }
#else
            ContentView.Wrapper(
                header: {
                    PartsView.DetailHeader(
                        title: kodi.host.name,
                        subtitle: kodi.status.message
                    )
                },
                content: {
                    content
                },
                buttons: {
                    Button {
                        scene.navigationStack.append(.appSettings)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            )
#endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenSafeArea()
        .animation(.easeInOut(duration: 1), value: status)
        .task(id: kodi.status) {

            switch kodi.status {
            case .loadedLibrary:
                try? await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                status = .ready
            case .offline:
                status = .offline
            case .outdatedLibrary:
                status = .empty
            default:
                status = .loading
            }
        }
    }

    // MARK: Content of the View

    /// The content of the `View`
    var content: some View {
        VStack {
            switch status {
            case.ready:
                ShelfView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            default:
                status.message(router: scene.mainSelection)
            }
        }
        .overlay(alignment: .bottom) {
            PartsView.RotatingIcon(rotate: true)
                .visualEffect { initial, geometry in
                    initial.scaleEffect(
                        CGSize(
                            width: status == .ready ? 0.8 : 1,
                            height: status == .ready ? 0.8 : 1
                        )
                    )
                    .offset(
                        x: status == .ready ? geometry.frame(in: .global).width / 2 : 0,
                        y: status == .ready ? geometry.frame(in: .global).height / 2 : 0
                    )
                }
        }
    }
}
