//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import UIKit

final class ChooseTrackerTypeViewController: UIViewController {
    
    var onCreateTracker: ((TrackerDraft) -> Void)?
    
    //MARK: - UI
    private let habitButton = TrackerTypeButton(title: "Привычка")
    private let eventButton = TrackerTypeButton(title: "Нерегулярное событие")
    
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
        
        setupButtons()
        setupNavigationBar()
        setupConstraints()
    }
    
    //MARK: - Private methods
    private func setupButtons() {
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Создание трекера"
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
        let vc = NewTrackerViewController(trackerType: .habit)
        vc.onCreateTracker = onCreateTracker
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = NewTrackerViewController(trackerType: .event)
        vc.onCreateTracker = onCreateTracker
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}
