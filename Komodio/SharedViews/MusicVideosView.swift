//
//  MusicVideosView().swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI
import SwiftUIRouter
import SwiftlyKodiAPI

struct MusicVideosView: View {
    /// The library filter
    @State var filter: KodiFilter
    var body: some View {
        Text("Music Videos View!")
    }
}
