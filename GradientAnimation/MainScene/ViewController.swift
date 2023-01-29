//
//  ViewController.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private static let willEnterForegroundKey = "willEnterForeground"
    private var isCardViewOpened: Bool = false
    private var isAnimationInProcess = true
    
    // MARK: - UI Elements
    private lazy var cardView: GradientView = {
        let view = GradientView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCardView))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(recognizer)
        
        return view
    }()
    
    private lazy var startStopAnimationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = #colorLiteral(red: 0.3060316145, green: 0.3324151635, blue: 0.3679077625, alpha: 1)
        button.tintColor = .white
        button.setTitle("Stop animation", for: .normal)
        button.addTarget(self, action: #selector(didTapStartStopAnimationButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var someActionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = #colorLiteral(red: 0.3060316145, green: 0.3324151635, blue: 0.3679077625, alpha: 1)
        button.tintColor = .white
        button.setTitle("Imitation of action", for: .normal)
        button.addTarget(self, action: #selector(didTapSomeActionButton), for: .touchUpInside)
        return button
    }()
    
    private var cardViewTopConstraint: NSLayoutConstraint?
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardView.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cardView.stopAnimation()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(cardView)
        self.view.addSubview(startStopAnimationButton)
        self.view.addSubview(someActionButton)
        setCardViewConstraints()
        setStartStopAnimationButtonConstraints()
        setSomeActionButtonConstraints()
    }
    
    // MARK: - Constraints
    private func setCardViewConstraints(isOpened: Bool = false) {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardViewTopConstraint = cardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: isOpened ? -20 : -80)
        
        NSLayoutConstraint.activate([
            cardViewTopConstraint!,
            cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40),
            cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40),
            cardView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func deactivateCardViewConstraints() {
        cardViewTopConstraint?.isActive = false
    }
    
    private func setStartStopAnimationButtonConstraints() {
        startStopAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startStopAnimationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 45),
            startStopAnimationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -45),
            startStopAnimationButton.heightAnchor.constraint(equalToConstant: 60),
            startStopAnimationButton.bottomAnchor.constraint(equalTo: someActionButton.topAnchor, constant: -20)
        ])
    }
    
    private func setSomeActionButtonConstraints() {
        someActionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            someActionButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 45),
            someActionButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -45),
            someActionButton.heightAnchor.constraint(equalToConstant: 60),
            someActionButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
    }
    
    // MARK: - UI Callbacks
    @objc
    private func didTapSomeActionButton() {
        isCardViewOpened = !isCardViewOpened
        tappingAnimation(for: someActionButton)
        animateCardView(isCardViewOpened)
    }
    
    @objc
    private func didTapStartStopAnimationButton() {
        if isAnimationInProcess {
            cardView.pauseAnimation()
            startStopAnimationButton.setTitle("Start animation", for: .normal)
        } else {
            cardView.resumeAnimatoin()
            startStopAnimationButton.setTitle("Stop animation", for: .normal)
        }
        tappingAnimation(for: startStopAnimationButton)
        isAnimationInProcess = !isAnimationInProcess
    }
    
    @objc
    private func didTapCardView() {
        isCardViewOpened = !isCardViewOpened
        animateCardView(isCardViewOpened)
    }
    
    // MARK: - Animation
    private func tappingAnimation(for button: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0) {
            button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        } completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func animateCardView(_ isOpened: Bool) {
        deactivateCardViewConstraints()
        setCardViewConstraints(isOpened: isOpened)

        UIView.animate(withDuration: 0.2, delay: 0) {
            self.cardView.transform = isOpened ? CGAffineTransform(scaleX: 1.1, y: 1.1) : CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
    }
    
}
