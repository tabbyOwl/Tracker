//
//   OptionRowView.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

final class OptionRowView: UIView {
    
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.right")
        imageView.image = image
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    //MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        setup(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Public methods
    func setSubtitle(_ text: String) {
        subtitleLabel.text = text
    }
    
    //MARK: - Private methods
    private func setup(title: String) {
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        titleLabel.text = title
        verticalStack.addArrangedSubviews(titleLabel, subtitleLabel)
        horizontalStack.addArrangedSubviews(verticalStack, imageView)
        addSubview(horizontalStack)
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
