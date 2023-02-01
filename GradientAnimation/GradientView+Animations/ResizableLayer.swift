//
//  ResizableLayer.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit
final class ResizableLayer: CALayer {
    override init() {
        super.init()
        sublayers?.removeAll()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        sublayers?.forEach { layer in
            layer.frame = self.frame
        }
    }
}
