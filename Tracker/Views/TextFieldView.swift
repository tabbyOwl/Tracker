//
//  TextFieldView.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/30.
//
import UIKit

final class TextFieldView: UIView {
    
    var onTextChanged: ((String) -> Void)?
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .appBackground
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.setLeftPadding(16)
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .appRed
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    init(placeholder: String?) {
        super.init(frame: .zero)
        textField.placeholder = placeholder
        setupUI()
        setupActions()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(textField, errorLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupActions() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func hideError() {
        errorLabel.isHidden = true
    }
}

extension TextFieldView: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return true
        }
        
        let maxCount = 38
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > maxCount {
            showError(String.localizedStringWithFormat(
                L10n.Common.characterLimit,
                maxCount
            ))
            return false
        } else {
            hideError()
            return true
        }
    }
}
