//
//  BubbleLayer.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit

class BubbleLayer: CAGradientLayer {
    
    private static let startPointKey = "startPoint"
    private static let endPointKey = "endPoint"
    private static let opcaityKey = "opacity"
    
    init(color: UIColor) {
        super.init()
        self.type = .radial
        
        let position = generateNewPosition()
        self.startPoint = position
        
        let radius = generateNewRadius()
        self.endPoint = displace(originalPoint: position, by: radius)
        
        set(color: color)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Settings
    func set(color: UIColor) {
        self.colors = [color.cgColor,
                       color.withAlphaComponent(0.5).cgColor,
                       color.withAlphaComponent(0.0).cgColor]
        self.locations = [0, 0.8, 1.0]
    }
    
    private func generateNewPosition() -> CGPoint {
        return CGPoint(x: CGFloat.random(in: 0.0...1.0),
                       y: CGFloat.random(in: 0.0...1.0))
    }
    
    private func generateNewRadius() -> CGPoint {
        let size = CGFloat.random(in: 0.15...0.75)
        let viewRatio = frame.width / frame.height
        let safeRatio = max(viewRatio.isNaN ? 1 : viewRatio, 1)
        let ratio = safeRatio * CGFloat.random(in: 0.25...1.75)
        return CGPoint(x: size, y: size * ratio)
    }
    
    private func displace(originalPoint: CGPoint, by point: CGPoint) -> CGPoint {
        return CGPoint(x: originalPoint.x + point.x,
                       y: originalPoint.y + point.y)
    }
    
    // MARK: Animations
    func animateLayer(speed: CGFloat) {
        guard speed > 0 else { return }
        
        self.removeAllAnimations()
        let currentLayer = self.presentation() ?? self
 
        let newStartPoint = generateNewPosition()
        let newRadius = generateNewRadius()
        let newEndPoint = displace(originalPoint: newStartPoint, by: newRadius)
        let newOpacity = Float.random(in: 0.5...1)
        
        // Transaction settings
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.23, 0.01, 0.77, 0.99))
        CATransaction.setAnimationDuration(1.7)
        
        let animation = CASpringAnimation()
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.delegate = self
        animation.mass = 10 / speed
        animation.damping = 50
        
        // animate opacity
        if let opacityAnimation = animation.copy() as? CASpringAnimation {
            opacityAnimation.fromValue = self.opacity
            opacityAnimation.toValue = newOpacity
            self.opacity = newOpacity
            self.add(opacityAnimation, forKey: BubbleLayer.opcaityKey)
        }
        
        // animate points
        if let startPointAnimation = animation.copy() as? CASpringAnimation {
            startPointAnimation.keyPath = BubbleLayer.startPointKey
            startPointAnimation.fromValue = currentLayer.startPoint
            startPointAnimation.toValue = newStartPoint
            self.add(startPointAnimation, forKey: BubbleLayer.startPointKey)
            self.startPoint = newStartPoint
        }
        
        if let endPointAnimation = animation.copy() as? CASpringAnimation {
            endPointAnimation.keyPath = BubbleLayer.endPointKey
            endPointAnimation.fromValue = currentLayer.endPoint
            endPointAnimation.toValue = newEndPoint
            self.add(endPointAnimation, forKey: BubbleLayer.endPointKey)
            self.endPoint = newEndPoint
        }
        
        CATransaction.commit()
    }
}

// MARK: - CAAnimationDelegate
extension BubbleLayer: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateLayer(speed: 1.0)
        }
    }
}
