//
//  GameScene.swift
//  gamegame
//
//  Created by Georgi Nikoloff on 05.09.22.
//

import MetalKit
import simd
import CoreImage

class GameScene: Node {
    var device: MTLDevice
//    var plane: Plane
    var cube: Cube
    
    init (device: MTLDevice) {
//        self.plane = Plane(device: device, imageName: "Images/picture.png")
//        self.plane.position.z = 2
        
        self.cube = Cube(device: device)
        self.cube.position.y = 0
        self.cube.position.z = 0
        
        self.device = device
        
        super.init()
        
//        self.addChild(child: plane)
        self.addChild(child: cube)
    }
    
    func onResize(size: CGSize) {
        // ...
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        self.cube.rotation.y += deltaTime
        for child in children {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime, parentModelMatrix: Transform.identityMatrix())
        }
    }
}
