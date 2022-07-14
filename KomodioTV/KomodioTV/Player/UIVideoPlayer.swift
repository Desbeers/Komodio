//
//  UIVideoPlayer.swift
//  KomodioTV
//
//  Created by Nick Berendsen on 11/07/2022.
//

import SwiftUI
import AVKit

struct UIVideoPlayer: UIViewControllerRepresentable {
    
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        vc.player = player
        vc.transportBarIncludesTitleView = false
        //vc.canStartPictureInPictureAutomaticallyFromInline = true
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
