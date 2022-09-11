//
//  Plane.swift
//  gamegame
//
//  Created by Georgi Nikoloff on 05.09.22.
//

import MetalKit

class Primitive: Node, Renderable, Texturable {
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    
    var time: Float = 0
    
    var vertexFunctionName = "vertexMain"
    var fragmentFunctionName = "fragmentMain"
    
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    var modelUniforms = ModelUniforms()
    
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }

    var texture: MTLTexture?
    
    init(device: MTLDevice) {
        super.init()
        buildVertices()
        buildBuffers(device)
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice, imageName: String) {
        super.init()
        
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "fragmentTexturedMain"
            
            print(fragmentFunctionName)
        }
        buildVertices()
        buildBuffers(device)
        pipelineState = buildPipelineState(device: device)
    }
    
    func buildVertices() {}
    
    private func buildBuffers(_ device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
        
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float, parentModelMatrix: simd_float4x4) {
        
        super.render(commandEncoder: commandEncoder, deltaTime: deltaTime, parentModelMatrix: modelMatrix)
        
        time += deltaTime

        modelUniforms.modelMatrix = parentModelMatrix * self.modelMatrix
        
//        commandEncoder.setFrontFacing(.clockwise)
//        commandEncoder.setCullMode(.back)
        
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&modelUniforms, length: MemoryLayout<ModelUniforms>.stride, index: 1)
        commandEncoder.setVertexBuffer(Renderer.instance.cameraUniformBuffer, offset: 0, index: 2)

        commandEncoder.setFragmentTexture(texture, index: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
    }
    
}

