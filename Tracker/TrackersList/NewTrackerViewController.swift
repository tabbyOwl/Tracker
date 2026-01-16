//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

final class NewTrackerViewController: UIViewController {
    let trackerType: TrackerType
    var onCreateTracker: ((TrackerDraft) -> Void)?
    
    // MARK: - Init
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    private var selectedSchedule: Set<WeekDay> = []
    
    // MARK: - UI
   
    private let categoryRow = OptionRowView(title: "Категория")
    private lazy var scheduleRow = OptionRowView(title: "Расписание")
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let bottomContainer: UIStackView = {
        let bottomContainer = UIStackView()
        bottomContainer.axis = .horizontal
        bottomContainer.spacing = 8
        bottomContainer.distribution = .fillEqually
        return bottomContainer
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.setLeftPadding(16)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .projectColor(.red)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let optionsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupGesture()
        setupConstraints()
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
        navigationItem.title = {
            switch trackerType {
            case .habit: return "Новая привычка"
            case .event: return "Новое событие"
            }
        }()
    }
    
    private func setupUI() {
        nameTextField.delegate = self
        view.backgroundColor = .white
        setupButtons()
        setupScheduleRow()
    }
    
    private func setupScheduleRow() {
        if trackerType == .event {
            scheduleRow.isHidden = true
            separatorView.isHidden = true
        }
    }
    
    private func setupButtons() {
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupGesture() {
        let categoryGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryRow.addGestureRecognizer(categoryGesture)
        
        if trackerType == .habit {
            let scheduleGesture = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
            scheduleRow.addGestureRecognizer(scheduleGesture)
        }
    }
    
    private func setupConstraints() {
        view.addSubviews(contentStackView, bottomContainer)
        contentStackView.addArrangedSubviews(nameTextField, errorLabel, optionsView)
        stackView.addArrangedSubviews(categoryRow, separatorView, scheduleRow)
        bottomContainer.addArrangedSubviews(cancelButton, createButton)
        optionsView.addSubview(stackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainer.isLayoutMarginsRelativeArrangement = true
        bottomContainer.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomContainer.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: optionsView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 60),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    //MARK: - Actions
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        let draft = TrackerDraft(
            type: trackerType,
            name: name,
            schedule: trackerType == .habit ? selectedSchedule : [],
            categoryId: TrackerCategory.defaultId
        )
        
        onCreateTracker?(draft)
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func categoryTapped() {
        // TO DO
    }
    
    @objc private func scheduleTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    private func hideError() {
        errorLabel.isHidden = true
    }
}
//MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: Set<WeekDay>) {
        selectedSchedule = days
        
        if days.count == WeekDay.allCases.count {
            scheduleRow.setSubtitle("Каждый день")
        } else {
            let sortedDays = days.sorted {$0.displayOrder < $1.displayOrder}
            scheduleRow.setSubtitle(
                sortedDays
                    .map { $0.shortTitle }
                    .joined(separator: ", ")
            )
        }
    }
}

extension NewTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return true
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > 38 {
            showError("Ограничение 38 символов")
            return false
        } else {
            hideError()
            return true
        }
    }
}
