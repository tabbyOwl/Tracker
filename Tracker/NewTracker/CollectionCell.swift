//
//  OptionCollectionCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/17.
//
import UIKit

protocol OptionCollectionCellDelegate: AnyObject {
    func itemSelected(_ item: OptionItem)
}

final class CollectionCell: UITableViewCell {
    
        static let identifier = "OptionCollectionCell"
    
        weak var delegate: OptionCollectionCellDelegate?
        private let optionRowView = OptionRowCollectionView(title: "", items: [])

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(optionRowView)
            setupConstraints()
            optionRowView.delegate = self
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupConstraints() {
            optionRowView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                optionRowView.topAnchor.constraint(equalTo: contentView.topAnchor),
                optionRowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                optionRowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                optionRowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        }

    func configure(title: String, items: [OptionItem]) {
        optionRowView.updateItems(title: title, items: items)
    }
}

extension CollectionCell: OptionRowCollectionViewDelegate {
    func itemSelected(_ item: OptionItem) {
        delegate?.itemSelected(item)
    }
}

