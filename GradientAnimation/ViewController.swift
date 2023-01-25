//
//  ViewController.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private var isCardViewOpened: Bool = false
    
    // MARK: - UI Elements
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var activateButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = #colorLiteral(red: 0.3060316145, green: 0.3324151635, blue: 0.3679077625, alpha: 1)
        button.tintColor = .white
        button.setTitle("Imitation of action", for: .normal)
        button.addTarget(self, action: #selector(didTapActivateButton), for: .touchUpInside)
        return button
    }()
    
    private var cardViewTopConstraint: NSLayoutConstraint?
    private var cardViewLeftConstraint: NSLayoutConstraint?
    private var cardViewRightConstraint: NSLayoutConstraint?

    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(cardView)
        self.view.addSubview(activateButton)
        setCardViewConstraints(isOpened: false)
        setActivateButtonConstraints()
    }
    
    // MARK: - Constraints
    private func setCardViewConstraints(isOpened: Bool) {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardViewLeftConstraint = cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: isOpened ? 20: 40)
        cardViewRightConstraint = cardView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: isOpened ? -20 : -40)
        cardViewTopConstraint = cardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: isOpened ? 0 : -80)
        
        NSLayoutConstraint.activate([
            cardViewTopConstraint!,
            cardViewLeftConstraint!,
            cardViewRightConstraint!,
            cardView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func deactivateCardViewConstraints() {
        guard let cardViewLeftConstraint,
              let cardViewRightConstraint,
              let cardViewTopConstraint
        else { return }
        
        NSLayoutConstraint.deactivate([
            cardViewTopConstraint,
            cardViewLeftConstraint,
            cardViewRightConstraint
        ])
    }
    
    private func setActivateButtonConstraints() {
        activateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activateButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            activateButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50),
            activateButton.heightAnchor.constraint(equalToConstant: 60),
            activateButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -70)
        ])
    }
    
    // MARK: - UI Callbacks
    @objc
    func didTapActivateButton() {
        isCardViewOpened = !isCardViewOpened
        tappingAnimation(for: activateButton)
        animateCardView(isCardViewOpened)
    }
}

// MARK: - Animations
extension ViewController {
    
    private func tappingAnimation(for button: UIButton) {
        UIView.animate(withDuration: 0.05, delay: 0) {
            button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        } completion: { _ in
            UIView.animate(withDuration: 0.05, delay: 0) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func animateCardView(_ isOpened: Bool) {
        deactivateCardViewConstraints()
        setCardViewConstraints(isOpened: isOpened)

        UIView.animate(withDuration: 0.2, delay: 0) {
            self.cardView.layer.cornerRadius = isOpened ? 20 : 15
            self.view.layoutIfNeeded()
        }
    }
    
}
