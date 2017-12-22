//
//  RatingComponent.swift
//  BeerApp
//
//  Created by Steven Van Durm on 20/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit

final class RatingComponent: UIView {
    fileprivate let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    fileprivate let plusButton: UIButton = {
        let button = UIButton()
        if let label = button.titleLabel {
            label.text = "+"
            label.textColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
        }
        return button
    }()
    fileprivate let minButton: UIButton = {
        let button = UIButton()
        if let label = button.titleLabel {
            label.text = "+"
            label.textColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
        }
        return button
    }()
    fileprivate lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.plusButton, self.minButton])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    fileprivate lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.textField, self.verticalStackView])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPhase2()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initPhase2()
    }
    
    private func initPhase2() {
        addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            horizontalStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            horizontalStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
            ])
    }
}
