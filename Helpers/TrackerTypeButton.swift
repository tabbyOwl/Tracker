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

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = .black
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
