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
        view.backgroundColor = .white
        navigationItem.title = "Редактировать категорию"
        
        // Setup the text field for the category name
        nameTextField.text = category.name
        nameTextField.font = .systemFont(ofSize: 16)
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocorrectionType = .no
        
        view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // "Готово" button
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - Actions
    @objc private func didTapDone() {
        let newName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let newName,
            !newName.isEmpty
        else {
            return
        }

        let updatedCategory = TrackerCategory(
            id: category.id,
            name: newName,
            trackers: category.trackers
        )

        onCategoryUpdated?(updatedCategory)

        dismiss(animated: true)
    }
}
