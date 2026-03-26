//
//  RowCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/17.
//
import UIKit

final class RowCell: UITableViewCell {
    
    static let identifier = "FormRowCell"
    
    var onSelect: ((String) -> Void)?
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .appGray
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .appGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        return stack
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .appBackground
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(title: String, subtitle: String? = nil, image: UIImage? = nil) {
        titleLabel.text = title
        
        if let subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
        
        if let image {
            self.image.image = image
            self.image.isHidden = false
        } else {
            self.image.isHidden = true
        }
    }
    
    func setCheckmark() {
        image.image = SystemImage.checkmark
        image.isHidden = false
    }
    
    private func setupConstraints() {
        contentView.addSubviews(horizontalStack)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        verticalStack.addArrangedSubviews(titleLabel, subtitleLabel)
        horizontalStack.addArrangedSubviews(verticalStack, image)
        
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        image.setContentHuggingPriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

