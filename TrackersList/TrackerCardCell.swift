//
//  TrackerCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/11.
//

import UIKit

protocol TrackerCardCellDelegate: AnyObject {
    func actionButtonTapped(_ cell: TrackerCardCell)
}

final class TrackerCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrackerCardCell"
    weak var delegate: TrackerCardCellDelegate?
    // MARK: - Subviews
    
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 1, alpha: 0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    // footer
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = "0 дней"
        label.textColor = .black
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let footerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateActionButton() {
        actionButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
    }
    // MARK: - Setup
    
    private func setupViews() {
        footerStack.addArrangedSubview(daysLabel)
        footerStack.addArrangedSubview(actionButton)
        
        cardView.addSubview(emojiLabel)
        cardView.addSubview(footerStack)
        cardView.addSubview(nameLabel)
        
        contentView.addSubview(cardView)
        contentView.addSubview(footerStack)
    }
    
    private func setupConstraints() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            actionButton.widthAnchor.constraint(equalToConstant: 34),
            actionButton.heightAnchor.constraint(equalToConstant: 34),
            actionButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            daysLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            
            footerStack.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            footerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footerStack.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    @objc private func actionButtonTapped() {
        delegate?.actionButtonTapped(self)
    }
    
    // MARK: - Configure
    
    func configure(emoji: String, name: String, color: UIColor) {
        emojiLabel.text = emoji
        nameLabel.text = name
        cardView.backgroundColor = color
        actionButton.backgroundColor = color
    }
}

