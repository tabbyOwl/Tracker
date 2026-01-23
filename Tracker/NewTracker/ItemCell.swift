//
//  OptionCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/17.
//
import UIKit

final class ItemCell: UICollectionViewCell {

    static let reuseIdentifier = "OptionItemCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()

    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private lazy var colorSquareView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        contentView.addSubview(backView)
        contentView.addSubview(label)
        backView.addSubview(colorSquareView)

        label.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false
        colorSquareView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backView.widthAnchor.constraint(equalToConstant: 52),
            backView.heightAnchor.constraint(equalToConstant: 52)
        ])

        NSLayoutConstraint.activate([
            colorSquareView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            colorSquareView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            colorSquareView.widthAnchor.constraint(equalToConstant: 40),
            colorSquareView.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        contentView.backgroundColor = .clear
    }

    func configure(with item: OptionItem, isSelected: Bool) {
        switch item {
        case .emoji(_, let emoji):
            label.text = emoji
            backView.backgroundColor = isSelected ? .projectColor(.lightGray) : .white
        case .color(_, let color):
            label.text = nil
            colorSquareView.backgroundColor = color
            let borderColor = color.withAlphaComponent(0.3).cgColor
            contentView.layer.borderColor = borderColor
            contentView.layer.borderWidth = isSelected ? 3 : 0
        }
    }
   
}
