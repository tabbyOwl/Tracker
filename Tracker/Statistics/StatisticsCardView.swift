//
//  StatisticsCardView.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/18.
//
import UIKit

final class StatisticsCardView: GradientBorderView {
    
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        
        colors = [.projectColor(.gradientRed), .projectColor(.gradientGreen), .projectColor(.gradientBlue)]
        layer.cornerRadius = 16
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 34, weight: .bold)
        
        let stackView = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func update(value: String) {
        valueLabel.text = value
    }
}
