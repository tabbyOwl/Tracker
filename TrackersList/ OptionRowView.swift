//
//   OptionRowView.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

final class OptionRowView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setSubtitle(_ text: String) {
        subtitleLabel.text = text
    }

    private func setup(title: String) {
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        titleLabel.text = title
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.tintColor = .systemGray
        
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        verticalStack.axis = .vertical
        stackView.addArrangedSubviews(verticalStack, image)
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        image.setContentHuggingPriority(.required, for: .horizontal)
        image.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
