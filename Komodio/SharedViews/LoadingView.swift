//
//  LoadingView.swift
//  Komodio
//
//  Created by Nick Berendsen on 25/02/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading your library")
                .font(.title)
            ProgressView()
        }
    }
}
