//
//  GradientView.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit

final class GradientView: UIView {
    
    // MARK: - Properties
    let bubbles: [UIColor] = [#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5873991847, green: 0.1840409338, blue: 0.9710285068, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5873991847, green: 0.1840409338, blue: 0.9710285068, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)]
    let highlights: [UIColor] = [#colorLiteral(red: 0.861065805, green: 0, blue: 0.7368372083, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0.7544654012, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    private(set) var isAnimationInProcess = false
    private(set) var speedOfAnimation: CGFloat = 1.0
    
    // MARK: - UIElements
    private let baseLayer = ResizableLayer()
    private let highlightLayer = ResizableLayer()
    
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    // MARK: - UIView lifecycle
    init() {
        super.init(frame: .zero)
        
        highlightLayer.backgroundFilters = ["overlayBlendMode"]
        
        self.layer.addSublayer(baseLayer)
        self.layer.addSublayer(highlightLayer)
        self.addSubview(blurEffectView)
        
        setBlurEffectViewConstraints()
        createSublayersIfNeeded(for: baseLayer, bubbles)
        createSublayersIfNeeded(for: highlightLayer, highlights)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    // MARK: - Setup UI
    private func setBlurEffectViewConstraints() {
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurEffectView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurEffectView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            blurEffectView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func createSublayersIfNeeded(for layer: CALayer, _ colors: [UIColor]) {
        let count = layer.sublayers?.count ?? 0
        let removeCount = count - colors.count
        if removeCount > 0 {
            layer.sublayers?.removeLast(removeCount)
        }
     
        for (index, color) in colors.enumerated() {
            if index < count {
                if let existing = layer.sublayers?[index] as? BubbleLayer {
                    existing.set(color: color)
                }
            } else {
                layer.addSublayer(BubbleLayer(color: color))
            }
        }
    }
    
    // MARK: - Update UI
    private func updateUI() {
        self.layer.frame = self.frame
        baseLayer.frame = self.layer.bounds
        highlightLayer.frame = self.layer.bounds
        
        updateCornerRadius(for: blurEffectView.layer)
        updateCornerRadius(for: baseLayer)
        updateCornerRadius(for: highlightLayer)
        
        baseLayer.layoutSublayers()
        highlightLayer.layoutSublayers()
    }
    
    private func updateCornerRadius(for layer: CALayer) {
        layer.cornerRadius = self.layer.cornerRadius
    }
    
    // MARK: - Animation
    func startAnimating(speed: CGFloat = 1.0) {
        guard !isAnimationInProcess else { return }
        
        isAnimationInProcess = true
        speedOfAnimation = speed
        
        self.animateLayer()
    }
    
    func stopAnimating() {
        guard isAnimationInProcess else { return }
        isAnimationInProcess = false
        
        stopAnimation()
    }
    
    private func animateLayer() {
        let layers = (baseLayer.sublayers ?? []) + (highlightLayer.sublayers ?? [])
        for layer in layers {
            if let layer = layer as? BubbleLayer {
                layer.animateLayer(speed: speedOfAnimation)
            }
        }
    }
    
    private func stopAnimation() {
        let layers = (baseLayer.sublayers ?? []) + (highlightLayer.sublayers ?? [])
        for layer in layers {
            if let layer = layer as? BubbleLayer {
                layer.removeAllAnimations()
            }
        }
    }
}
