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
    
    private let textFieldView = TextFieldView(placeholder: "Введите название категории")
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldView.onTextChanged = { [weak self] text in
               self?.name = text
           }
        setupUI()
        setupNavigationBar()
        setupKeyboard()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новая категория"
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
        view.addSubviews(textFieldView, doneButton)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    @objc private func didTapDoneButton() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        onCategoryCreated?(name)
        dismiss(animated: true)
    }
}
