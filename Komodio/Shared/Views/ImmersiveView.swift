//
//  ImmersiveView.swift
//  Komodio
//
//  Created by Nick Berendsen on 22/08/2023.
//

#if os(visionOS)

import SwiftUI
import SwiftlyKodiAPI
import RealityKit

struct ImmersiveView: View {
    /// The fanart
    let fanart: String
    /// The body of the `View`
    var body: some View {
        RealityView { content, attachments  in
            let rootEntity = Entity()
            guard
                /// Convert the string to a full Kodi URL
                let url = URL(string: Files.getFullPath(file: fanart, type: .art)),
                /// Try to find it in the art cache, it will be an UIImage
                let cachedImage = KodiArt.cache.object(forKey: url.absoluteString as NSString),
                /// Get the optional cgImage
                let cgImage = cachedImage.cgImage,
                /// Convert it to a texture
                let texture = try? TextureResource.generate(from: cgImage, options: .init(semantic: .normal))
            else {
                return
            }
            var material = SimpleMaterial()
            material.color = .init(texture: .init(texture))
            rootEntity.components.set(ModelComponent(
                mesh: .generateBox(width: 2.67, height: 1.5, depth: 2),
                materials: [material]
            ))
            rootEntity.scale *= .init(x: -1, y: 1, z: 1)
            rootEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
            content.add(rootEntity)
            if let titleAttachment = attachments.entity(for: "movietitle") {
                titleAttachment.position = [0, 0, 0]
                rootEntity.addChild(titleAttachment)
            }
        } attachments: {
            Text("Playing a movie").scaleEffect(x: -1, y: 1).tag("movietitle")
        }
    }
}
#endif
