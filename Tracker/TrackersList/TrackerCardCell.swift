//
//  TrackerCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/11.
//

import UIKit

protocol TrackerCardCellDelegate: AnyObject {
    func actionButtonTapped(_ cell: TrackerCardCell)
    func didPinItem(at indexPath: IndexPath)
    func didDeleteItem(at indexPath: IndexPath)
    func didEditItem(at indexPath: IndexPath)
    
}

final class TrackerCardCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCardCell"
    weak var delegate: TrackerCardCellDelegate?
    var indexPath: IndexPath?
    private var isPinned: Bool = false
    
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
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(SystemImage.plus, for: .normal)
        button.tintColor = .appWhite
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
    
    private let pinImageView: UIImageView = {
        let view = UIImageView()
        view.image = SystemImage.pin
        view.tintColor = .white
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupViews()
        setupConstraints()
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - Public methods
    func configure(with tracker: Tracker, isCompleted: Bool, completedDaysCount: Int, indexPath: IndexPath) {
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.name
        cardView.backgroundColor = tracker.color
        actionButton.backgroundColor = tracker.color
        
        let isCompleted = isCompleted
        actionButton.setImage(isCompleted ? SystemImage.checkmark : SystemImage.plus, for: .normal)
        
        daysLabel.text = String.localizedStringWithFormat(
            L10n.Tracker.daysCount,
            completedDaysCount
        )
        isPinned = tracker.isPinned
        pinImageView.isHidden = !isPinned
        self.indexPath = indexPath
    }
    
    // MARK: - Private methods
    private func setupViews() {
        footerStack.addArrangedSubviews(daysLabel, actionButton)
        cardView.addSubviews(emojiLabel, nameLabel, pinImageView)
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
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            pinImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            pinImageView.heightAnchor.constraint(equalToConstant: 12),
            
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
}

extension TrackerCardCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPath else { return nil }
        let title = isPinned ? L10n.Trackers.unpinButtonTitle : L10n.Trackers.pinButtonTitle
        let pinAction = UIAction(title: title, image: nil) { action in
            self.delegate?.didPinItem(at: indexPath)
        }
        
        let editAction = UIAction(title: L10n.Common.edit, image: nil) { action in
            self.delegate?.didEditItem(at: indexPath)
        }
        
        let deleteAction = UIAction(title: L10n.Common.delete, image: nil) { action in
            self.delegate?.didDeleteItem(at: indexPath)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [pinAction, editAction, deleteAction])
            
        }
    }
}
