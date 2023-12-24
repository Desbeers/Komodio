//
//  ImmersiveView.swift
//  Komodio (visionOS)
//
//  © 2023 Nick Berendsen
//

#if os(visionOS)

import SwiftUI
import SwiftlyKodiAPI
import RealityKit

struct ImmersiveView: View {
    /// The media item
    let media: MediaItem
    /// The Kodi item
    @State private var kodiItem: (any KodiItem)?
    /// The body of the `View`
    var body: some View {
        RealityView { content, attachments  in
            let rootEntity = Entity()
            guard
                /// Get the video
                let video = await Application.getItem(type: media.media, id: media.id),
                /// Convert the string to a full Kodi URL
                let url = URL(string: Files.getFullPath(file: video.fanart, type: .art)),
                /// Try to find it in the art cache, it will be an UIImage
                let cachedImage = KodiArt.cache.object(forKey: url.absoluteString as NSString),
                /// Get the optional cgImage
                let cgImage = cachedImage.cgImage,
                /// Convert it to a texture
                let texture = try? await TextureResource.generate(from: cgImage, options: .init(semantic: .normal))
            else {
                return
            }
            self.kodiItem = video
            var material = SimpleMaterial()
            // var material = UnlitMaterial()
            material.color = .init(texture: .init(texture))
            rootEntity.components.set(ModelComponent(
                mesh: .generateBox(width: 2.67, height: 1.5, depth: 2),
                materials: [material]
            ))
            rootEntity.scale *= .init(x: -1, y: 1, z: 1)
            rootEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
            content.add(rootEntity)
            if let titleAttachment = attachments.entity(for: "movietitle") {
                titleAttachment.position = .init(x: 0.6, y: 0, z: -0.6)
                rootEntity.addChild(titleAttachment)
            }
        } attachments: {
            Attachment(id: "movietitle") {
                VStack {
                    Text(kodiItem?.title ?? "Playing a movie")
                        .scaleEffect(x: -1, y: 1)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .padding(.top)
                    KodiArt.Poster(item: kodiItem)
                        .clipShape(.rect(cornerRadius: 30))
                }
                .frame(width: 200)
                .padding()
                .glassBackgroundEffect()
            }
        }
    }
}
#endif
