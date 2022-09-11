//
//  Texturable.swift
//  gamegame
//
//  Created by Georgi Nikoloff on 05.09.22.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture? = nil
        
        if let textureUrl = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureUrl, options: [MTKTextureLoader.Option.origin: MTKTextureLoader.Origin.bottomLeft.rawValue])
            } catch {
                print("texture not created")
            }
        }
        return texture
    }
}
