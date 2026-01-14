//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func createHabit(name: String)
    func createEvent(name: String)
}

final class NewTrackerViewController: UIViewController {
    
    let trackerType: TrackerType
    
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    // MARK: - UI
    private let contentStackView = UIStackView()
    private var selectedSchedule: Set<WeekDay> = []
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.setLeftPadding(16)
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return textField
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
    
    private let categoryRow = OptionRowView(title: "Категория")
    private let scheduleRow = OptionRowView(title: "Расписание")
    
    private let bottomContainer = UIStackView()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupGesture()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = {
            switch trackerType {
            case .habit: return "Новая привычка"
            case .event: return "Новое событие"
            }
        }()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        contentStackView.axis = .vertical
        contentStackView.spacing = 24

        bottomContainer.axis = .horizontal
        bottomContainer.spacing = 8
        bottomContainer.distribution = .fillEqually

        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        if trackerType == .event {
            scheduleRow.isHidden = true
            separatorView.isHidden = true
        }
    }
    
    private func setupGesture() {
        let categoryGesture = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        categoryRow.addGestureRecognizer(categoryGesture)

        if trackerType == .habit {
            let scheduleGesture = UITapGestureRecognizer(target: self, action: #selector(scheduleTapped))
            scheduleRow.addGestureRecognizer(scheduleGesture)
        }
    }
    
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else { return }

        switch trackerType {
        case .habit:
            delegate?.createHabit(name: name)

        case .event:
            delegate?.createEvent(name: name)
        }

        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func categoryTapped() {
        
    }
    
    @objc private func scheduleTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(scheduleVC, animated: true)
    }
    
    private func setupLayout() {
        view.addSubviews(contentStackView, bottomContainer)
        contentStackView.addArrangedSubviews(nameTextField, optionsView)
        stackView.addArrangedSubviews(categoryRow, separatorView, scheduleRow)
        bottomContainer.addArrangedSubviews(cancelButton, createButton)
        optionsView.addSubview(stackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomContainer.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: optionsView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: -20),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: Set<WeekDay>) {
        selectedSchedule = days
        let sortedDays = days.sorted {$0.displayOrder < $1.displayOrder}
                scheduleRow.setSubtitle(
                    sortedDays
                        .map { $0.shortTitle }
                        .joined(separator: ", ")
                )
    }
}
