//
//  MetalCoinRenderer.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 04/02/2025.
//

import UIKit
import MetalKit
import ModelIO
import SceneKit
import SceneKit.ModelIO
import SnapKit

class CoinView: UIView {
    private var metalView: MTKView!
    private var renderer: CoinRenderer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMetalView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMetalView()
    }
    
    private func setupMetalView() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device.")
        }

        metalView = MTKView(frame: .zero, device: device)
        self.addSubview(metalView)

        metalView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(metalView.snp.width)
        }
        
        renderer = CoinRenderer(metalView: metalView)
    }
    
    func toggleState(isLoading: Bool) {
        renderer.setRotationSpeed(isLoading)
    }
}
