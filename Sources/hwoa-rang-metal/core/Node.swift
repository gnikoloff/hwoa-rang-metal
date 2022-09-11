//
//  Node.swift
//  gamegame
//
//  Created by Georgi Nikoloff on 05.09.22.
//

import MetalKit

class Node {
    let uuid = UUID()
    
    var name = "untitled"
    var children: [Node] = []
    
    internal var _cachedModelMatrix = simd_float4x4();
    internal var _recomputeModelMatrix = true
    
    internal var _position = SIMD3<Float>(0, 0, 0)
    var position: SIMD3<Float> {
        get { return _position }
        set { _position = newValue; _recomputeModelMatrix = true }
    }
    
    internal var _scale = SIMD3<Float>(1, 1, 1)
    var scale: SIMD3<Float> {
        get { return _scale }
        set { _scale = newValue; _recomputeModelMatrix = true }
    }
    
    internal var _rotation = SIMD3<Float>(0, 0, 0)
    var rotation: SIMD3<Float> {
        get { return _rotation }
        set { _rotation = newValue; _recomputeModelMatrix = true }
    }
    
    var modelMatrix: simd_float4x4 {
        if (!_recomputeModelMatrix) {
            return _cachedModelMatrix
        }
        _cachedModelMatrix = Transform.translationMatrix(position)
        _cachedModelMatrix *= Transform.rotationMatrix(radians: rotation.x, axis: SIMD3(1, 0, 0))
        _cachedModelMatrix *= Transform.rotationMatrix(radians: rotation.y, axis: SIMD3(0, 1, 0))
        _cachedModelMatrix *= Transform.rotationMatrix(radians: rotation.z, axis: SIMD3(0, 0, 1))
        _cachedModelMatrix *= Transform.scaleMatrix(scale)
        _recomputeModelMatrix = false
        return _cachedModelMatrix
    }
    
    func addChild(child: Node) {
        children.append(child)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float, parentModelMatrix: simd_float4x4) {
        var modelMatrix = self.modelMatrix
        modelMatrix = parentModelMatrix * modelMatrix
        for child in children {
            child.render(commandEncoder: commandEncoder, deltaTime: deltaTime, parentModelMatrix: modelMatrix)
        }
    }
}
