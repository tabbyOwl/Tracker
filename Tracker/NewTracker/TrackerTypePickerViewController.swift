//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import UIKit

final class TrackerTypePickerViewController: UIViewController {
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    //MARK: - UI
    private let habitButton = TrackerTypeButton(title: L10n.trackerTypeHabit)
    private let eventButton = TrackerTypeButton(title: L10n.trackerTypeEvent)
    
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()
        setupNavigationBar()
        setupConstraints()
    }
    
    //MARK: - Private methods
    private func setupButtons() {
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        navigationItem.title = L10n.trackerCreationTitle
    }
    
    private func setupConstraints() {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(habitButton)
        buttonsStack.addArrangedSubview(eventButton)
        
        NSLayoutConstraint.activate([
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    //MARK: - Actions
    @objc private func habitButtonTapped() {
        let vc = TrackerFormViewController(mode: .create(type: .habit))
        vc.onSaveTracker = onCreateTracker
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = TrackerFormViewController(mode: .create(type: .event))
        vc.onSaveTracker = onCreateTracker
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}
