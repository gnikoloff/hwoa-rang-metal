//
//  Cube.swift
//  gamegame
//
//  Created by Georgi Nikoloff on 10.09.22.
//

import simd

class CubeGeometry {
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    var numberOfVertices: UInt = 0
    
    init(
        width: Float = 1,
        height: Float = 1,
        depth: Float = 1,
        widthSegments: UInt = 1,
        heightSegments: UInt = 1,
        depthSegments: UInt = 1
    ) {
        buildPlane(2, 1, 0, -1, -1, depth, height,  width,  depthSegments, heightSegments) // px
        buildPlane(2, 1, 0,  1, -1, depth, height, -width,  depthSegments, heightSegments) // nx
        buildPlane(0, 2, 1,  1,  1, width, depth,   height, widthSegments, depthSegments)  // py
        buildPlane(0, 2, 1,  1, -1, width, depth,  -height, widthSegments, depthSegments)  // ny
        buildPlane(0, 1, 2,  1, -1, width, height,  depth,  widthSegments, heightSegments) // pz
        buildPlane(0, 1, 2, -1, -1, width, height, -depth,  widthSegments, heightSegments) // nz
        
    }
    
    private func buildPlane(
        _ u: Int,
        _ v: Int,
        _ w: Int,
        _ uDir: Float,
        _ vDir: Float,
        _ width: Float,
        _ height: Float,
        _ depth: Float,
        _ gridX: UInt,
        _ gridY: UInt
    ) {
        let segmentWidth = width / Float(gridX)
        let segmentHeight = height / Float(gridY)
        let widthHalf = width / 2
        let heightHalf = height / 2
        let depthHalf = depth / 2
        let gridX1 = gridX + 1
        let gridY1 = gridY + 1
        
        var vertexCounter: UInt = 0
        
        var vector3 = simd_float3()
        var vector2 = simd_float2()
        
        // vertices + uvs
        
        for iy in 0..<gridY1 {
            let y = Float(iy) * segmentHeight - heightHalf
            for ix in 0..<gridX1 {
                let x = Float(ix) * segmentWidth - widthHalf
                vector3[u] = x * uDir
                vector3[v] = y * vDir
                vector3[w] = depthHalf
                
                vector2.x = Float(ix) / Float(gridX)
                vector2.y = 1 - Float(iy) / Float(gridY)
                
                let vertex = Vertex(position: vector3, uv: vector2)
                vertices.append(vertex)
                
                vertexCounter += 1
            }
        }
        
        // indices
        
        for iy in 0..<gridY {
            for ix in 0..<gridX {
                let a = numberOfVertices + ix + gridX1 * iy;
                let b = numberOfVertices + ix + gridX1 * (iy + 1);
                let c = numberOfVertices + (ix + 1) + gridX1 * (iy + 1);
                let d = numberOfVertices + (ix + 1) + gridX1 * iy;

                indices.append(UInt16(a))
                indices.append(UInt16(b))
                indices.append(UInt16(d))
                indices.append(UInt16(b))
                indices.append(UInt16(c))
                indices.append(UInt16(d))
            }
        }
        
        
        numberOfVertices += vertexCounter
        
    }
}
