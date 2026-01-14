//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import UIKit

final class ChooseTrackerTypeViewController: UIViewController {
    
    private let habitButton = TrackerTypeButton(title: "Привычка")
    private let eventButton = TrackerTypeButton(title: "Нерегулярное событие")
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupButtons() {
        habitButton.addTarget(self, action: #selector(habbitButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Создание трекера"
    }
    
    private func setupLayout() {
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
    
    @objc private func habbitButtonTapped() {
        let vc = NewTrackerViewController(trackerType: .habit)
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let vc = NewTrackerViewController(trackerType: .event)
        present(UINavigationController(rootViewController: vc), animated: true)
    }
}
