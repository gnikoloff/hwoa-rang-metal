//
//  Camera.swift
//  gamegame
//
//  Created by Georgi Nikoloff on 05.09.22.
//

import simd

final class Camera: Node {
    private static let UP_VECTOR = SIMD3<Float>(0, 1, 0)
    
    private var _recomputeViewMatrix = true
    private var _cachedViewMatrix = simd_float4x4()
    private var _recomputeProjectionMatrix = true
    private var _cachedProjectionMatrix = simd_float4x4()
    
    private var _aspect: Float = 1
    var aspect: Float {
        get { return _aspect }
        set { _aspect = newValue; _recomputeProjectionMatrix = true }
    }
    
    private var _fovRadians: Float = 40 * Float.pi / 180
    var fovRadians: Float {
        get { return _fovRadians }
        set { _fovRadians = newValue; _recomputeProjectionMatrix = true }
    }
    
    private var _nearZ: Float = 0.1
    var nearZ: Float {
        get { return _nearZ }
        set { _nearZ = newValue; _recomputeProjectionMatrix = true }
    }
    
    private var _farZ: Float = 100
    var farZ: Float {
        get { return _farZ }
        set { _farZ = newValue; _recomputeProjectionMatrix = true }
    }
    
    private var _lookAtTarget: SIMD3<Float> = SIMD3(0, 0, 0)
    var lookAtTarget: SIMD3<Float> {
        get { return _lookAtTarget }
        set { _lookAtTarget = newValue; _recomputeViewMatrix = true }
    }
    
    override var position: SIMD3<Float> {
        get { return _position }
        set {
            _position = newValue;
            _recomputeModelMatrix = true;
            _recomputeViewMatrix = true
        }
    }

    var viewMatrix: simd_float4x4 {
        if (!_recomputeViewMatrix) {
            return _cachedViewMatrix
        }
        _cachedViewMatrix = Transform.look(eye: position, target: lookAtTarget, up: Camera.UP_VECTOR)
        _recomputeViewMatrix = false
        return _cachedViewMatrix
    }
    var projectionMatrix: simd_float4x4 {
        if (!_recomputeProjectionMatrix) {
            return _cachedProjectionMatrix
        }
        _cachedProjectionMatrix = Transform.perspectiveProjection(fovRadians, aspect, nearZ, farZ)
        _recomputeProjectionMatrix = false
        return _cachedProjectionMatrix
    }
    
}
