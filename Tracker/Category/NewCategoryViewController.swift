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
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = .projectColor(.backgroundDay)
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.setLeftPadding(16)
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .projectColor(.red)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
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
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        view.addSubviews(stackView, doneButton)
        stackView.addArrangedSubviews(textField, errorLabel)
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        name = textField.text ?? ""
    }
    
    @objc private func didTapDoneButton(_ textField: UITextField) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        onCategoryCreated?(name)
        dismiss(animated: true)
    }
    
}

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return true
        }
        let maxCount = 38
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > maxCount {
            showError("Ограничение \(maxCount) символов")
            return false
        } else {
            hideError()
            return true
        }
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func hideError() {
        errorLabel.isHidden = true
    }
}
