//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/28.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    var onCategoryCreated: ((String) -> Void)?
    private var name: String = ""
    
    private let textField = TextFieldView(placeholder: L10n.NewCategory.placeholder)
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Common.done, for: .normal)
        button.setTitleColor(.appWhite, for: .normal)
        button.backgroundColor = .appBlack
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        setupUI()
        setupNavigationBar()
        setupKeyboard()
    }
    
    private func setupTextField() {
        textField.onTextChanged = { [weak self] text in
            self?.name = text
            self?.updateDoneButtonState()
        }
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .appWhite
        navigationItem.title = L10n.NewCategory.title
    }
    
    private func setupKeyboard() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = .appWhite
        view.addSubviews(textField, doneButton)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    private func updateDoneButtonState() {
        let isValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
        doneButton.isEnabled = isValid
        doneButton.backgroundColor = isValid ? .appBlack : .appLightGray
    }
    
    @objc private func didTapDoneButton() {
        onCategoryCreated?(name)
        dismiss(animated: true)
    }
}
