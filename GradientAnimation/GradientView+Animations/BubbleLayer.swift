//
//  BubbleLayer.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit

class BubbleLayer: CAGradientLayer {
    
    // MARK: - Properties
    private static let startPointKey = "startPointKey"
    private static let endPointKey = "endPointKey"
    private static let opcaityKey = "opacityKey"
    
    private var animationInProcess = false
    
    // MARK: - Lifecycle
    init(color: UIColor) {
        super.init()
        setNotificationCenter()
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Application lifecycle
    @objc
    private func applicationDidBecomeActive() {
        guard animationInProcess else { return }
        animationInProcess = false
        self.startAnimation()
    }
    
    @objc
    private func applicationWillResignActive() {
        guard animationInProcess else { return }
        self.stopAnimation()
        animationInProcess = true
    }
    
    // MARK: - Settings
    public func set(color: UIColor) {
        self.colors = [color.cgColor,
                       color.withAlphaComponent(0.5).cgColor,
                       color.withAlphaComponent(0.0).cgColor]
        self.locations = [0, 0.8, 1.0]
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.didEnterBackgroundNotification, object: nil)
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
    
    // MARK: - Animation control
    public func startAnimation() {
        guard !animationInProcess else { return }
        animationInProcess = true
        animateLayer()
    }
    
    public func stopAnimation() {
        guard animationInProcess else { return }
        animationInProcess = false
        self.removeAllAnimations()
    }
    
    public func pauseAnimation() {
        guard animationInProcess else { return }
        animationInProcess = false
        let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }
    
    public func resumeAnimation() {
        guard !animationInProcess else { return }
        animationInProcess = true
        
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
    
    // MARK: - Animation process
    private func animateLayer() {
        let speed: CGFloat = 1.0
        
        self.removeAllAnimations()
        self.speed = 1.0
        self.beginTime = 0.0
        let currentLayer = self.presentation() ?? self
 
        let newStartPoint = generateNewPosition()
        let newRadius = generateNewRadius()
        let newEndPoint = displace(originalPoint: newStartPoint, by: newRadius)
        let newOpacity = Float.random(in: 0.5...1)
        
        // CATransaction settings
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
        guard flag else { return }
        
        if animationInProcess {
            animateLayer()
        }
    }
}
