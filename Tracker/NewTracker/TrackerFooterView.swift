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
    
    private let mode: TrackerFormMode?
    private let cancelButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)
    
    init(mode: TrackerFormMode? = nil) {
        self.mode = mode
        super.init(frame: .zero)
        setupUI()
        configureForMode()
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
        
        cancelButton.setTitle(L10n.Common.cancel, for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemRed.cgColor
        cancelButton.layer.cornerRadius = 16
        
        createButton.backgroundColor = .lightGray
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
    
    private func configureForMode() {
        switch mode {
        case .create:
            createButton.setTitle(L10n.Common.create, for: .normal)

        case .edit:
            createButton.setTitle("Сохранить", for: .normal)
        case .none:
            return
        }
    }
    
    func setCreateButtonState(_ isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .black : .lightGray
    }
    
    @objc private func cancelTapped() {
        onCancel?()
    }
    
    @objc private func createTapped() {
        onCreate?()
    }
}
