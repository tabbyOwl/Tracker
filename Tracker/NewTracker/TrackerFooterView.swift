//
//  TrackerFooterView.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/17.
//
import UIKit

final class TrackerFooterView: UIView {

    var onCancel: (() -> Void)?
    var onCreate: (() -> Void)?

    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually

        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemRed.cgColor
        cancelButton.layer.cornerRadius = 16

        createButton.setTitle("Создать", for: .normal)
        createButton.backgroundColor = .projectColor(.blackDay)
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 16

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalToConstant: 60)
        ])

        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
    }

    @objc private func cancelTapped() {
        onCancel?()
    }

    @objc private func createTapped() {
        onCreate?()
    }
}
