//
//  MetalCoinView.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 04/02/2025.
//

import UIKit
import MetalKit
import ModelIO
import SceneKit
import SceneKit.ModelIO
import SceneKit

class CoinRenderer: NSObject, MTKViewDelegate {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var scene: SCNScene!
    private var scnRenderer: SCNRenderer!
    private var coinNode: SCNNode!
    private var rotationSpeed: Float = 1.0
    
    init(metalView: MTKView) {
        guard let device = metalView.device else {
            fatalError("Metal device not available")
        }
        self.device = device
        self.commandQueue = device.makeCommandQueue()!
        
        super.init()
        metalView.delegate = self
        metalView.isOpaque = false
        metalView.backgroundColor = .clear
        metalView.framebufferOnly = false

        loadModel()
        setupRenderer(metalView: metalView)
    }
    
    private func loadModel() {
        scene = SCNScene(named: "coin.usdz")
        
        scene.background.contents = nil

        coinNode = scene.rootNode.childNodes.first

        coinNode.position = SCNVector3(0, 0, -400)

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.position = SCNVector3(0, 10, 10)
        scene.rootNode.addChildNode(lightNode)
    }
    
    private func setupRenderer(metalView: MTKView) {
        scnRenderer = SCNRenderer(device: device, options: nil)
        scnRenderer.scene = scene
        scnRenderer.scene?.background.contents = UIColor.clear
    }
    
    private var lastUpdateTime: TimeInterval = CACurrentMediaTime()
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        let rotationIncrement = deltaTime * Double(rotationSpeed) * 2 * .pi
        coinNode.rotation = SCNVector4(0, 1, 0, coinNode.rotation.w + Float(rotationIncrement))
        
        let viewportSize = view.bounds.width * 3
        scnRenderer.render(
            atTime: CACurrentMediaTime(),
            viewport: CGRect(
                x: (view.drawableSize.width - viewportSize) / 2,
                y: (view.drawableSize.height - viewportSize) / 2,
                width: viewportSize,
                height: viewportSize
            ),
            commandBuffer: commandBuffer,
            passDescriptor: renderPassDescriptor
        )
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
        

    private var animationInProgress = false

    func setRotationSpeed(_ isLoading: Bool, duration: TimeInterval = 2.0) {
        let targetSpeed: Float = isLoading ? 0.7 : 0.05
        
        if rotationSpeed == targetSpeed { return }

        let oldSpeed = rotationSpeed
        let startTime = CACurrentMediaTime()

        animationInProgress = true

        func updateSpeed() {
            let elapsedTime = CACurrentMediaTime() - startTime
            let progress = min(Float(elapsedTime / duration), 1.0)
            let easedProgress = 0.5 * (1 - cos(progress * .pi))
            rotationSpeed = oldSpeed + (targetSpeed - oldSpeed) * easedProgress

            if progress < 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                    updateSpeed()
                }
            } else {
                rotationSpeed = targetSpeed
                animationInProgress = false
            }
        }

        updateSpeed()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
}
