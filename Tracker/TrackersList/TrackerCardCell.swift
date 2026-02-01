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
    
    // MARK: - UI
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
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 17
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
        setupButton()
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Public methods
    func configure(with tracker: Tracker, isCompleted: Bool, completedDaysCount: Int) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        cardView.backgroundColor = tracker.color
        actionButton.backgroundColor = tracker.color
        
        let isCompleted = isCompleted
        actionButton.setImage(UIImage(systemName: isCompleted ? "checkmark" : "plus"), for: .normal)
        
        let count = completedDaysCount
        daysLabel.text = "\(count) \(getDayWord(for: count))"
    }
    
    // MARK: - Private methods
    private func setupViews() {
        footerStack.addArrangedSubviews(daysLabel, actionButton)
        cardView.addSubviews(emojiLabel, nameLabel)
        contentView.addSubviews(cardView, footerStack)
    }
    
    private func setupButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
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
    
    private func getDayWord(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 { return "дней" }
        switch lastDigit {
        case 1: return "день"
        case 2,3,4: return "дня"
        default: return "дней"
        }
    }
    
    @objc private func actionButtonTapped() {
        delegate?.actionButtonTapped(self)
    }
}

