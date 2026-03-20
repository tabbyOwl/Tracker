//
//  TrackerTypeButton.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import UIKit

final class TrackerTypeButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private func setup() {
        backgroundColor = .secondarySystemBackground
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
