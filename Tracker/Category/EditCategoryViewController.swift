//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/30.
//

import UIKit

final class EditCategoryViewController: UIViewController {

    // MARK: - Properties
    var category: TrackerCategory
    var onCategoryUpdated: ((TrackerCategory) -> Void)?
    
    private let nameTextField = UITextField()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.done, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    // MARK: - Initializer
    init(category: TrackerCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        view.backgroundColor = .white
        navigationItem.title = L10n.editCategoryTitle
        
        nameTextField.text = category.name
        nameTextField.font = .systemFont(ofSize: 16)
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocorrectionType = .no
        
        view.addSubview(nameTextField)
        view.addSubview(doneButton)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            nameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
    }
    
    // MARK: - Actions
    @objc private func didTapDone() {
        let newName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let newName, !newName.isEmpty else { return }

        let updatedCategory = TrackerCategory(id: category.id, name: newName, trackers: category.trackers)

        onCategoryUpdated?(updatedCategory)

        dismiss(animated: true)
    }
}
