//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

final class NewTrackerViewController: UIViewController {
    
    // MARK: - Public
    let trackerType: TrackerType
    var onCreateTracker: ((TrackerDraft) -> Void)?
    
    // MARK: - State
    private var name: String = ""
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var selectedSchedule: Set<WeekDay> = []
    private var scheduleIndexPath: IndexPath?
    private var categoryIndexPath: IndexPath?
    private var category: TrackerCategory?
    
    // MARK: - Sections
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .projectColor(.backgroundDay)
        textField.layer.cornerRadius = 16
        textField.font = .systemFont(ofSize: 17)
        textField.setLeftPadding(16)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .projectColor(.red)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private enum Section: Int, CaseIterable {
        case options
        case collection
    }
    
    private enum CollectionType {
        case emoji
        case color
        
        var title: String {
            switch self {
            case .emoji: "Emoji"
            case .color: "Цвет"
            }
        }
    }
    
    private var scheduleSubtitle: String? {
        guard !selectedSchedule.isEmpty else { return nil }
        
        if selectedSchedule.count == WeekDay.allCases.count {
            return "Каждый день"
        }
        
        return selectedSchedule
            .sorted { $0.displayOrder < $1.displayOrder }
            .map { $0.shortTitle }
            .joined(separator: ", ")
    }
    
    private let collectionTypes: [CollectionType] = [.emoji, .color]
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    // MARK: - Init
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setupUI()
        setupNavigationBar()
        registerCells()
        setupFooter()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
        stackView.addArrangedSubviews(textField, errorLabel)
        
        view.addSubviews(stackView, tableView)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    
    private func registerCells() {
        tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        tableView.register(CollectionCell.self, forCellReuseIdentifier: CollectionCell.identifier)
    }
    
    private func setupFooter() {
        let footer = TrackerFooterView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 120))
        
        footer.onCancel = { [weak self] in
            self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        footer.onCreate = { [weak self] in
            self?.createTracker()
        }
        
        tableView.tableFooterView = footer
    }
    
    private func createTracker() {
        guard !name.isEmpty else { return }
        
        guard
            let category = category,
            let selectedEmoji = selectedEmoji,
            let selectedColor = selectedColor
        else { return }
        
        if trackerType == .habit && selectedSchedule.isEmpty {
                return
            }

        let draft = TrackerDraft(
            type: trackerType,
            name: name,
            emoji: selectedEmoji,
            color: selectedColor,
            schedule: trackerType == .habit ? selectedSchedule : [],
            category: category
        )
        
        onCreateTracker?(draft)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func categoryTapped() {
        let vc = CategoryPickerViewController()
        vc.onCategorySelected = { [weak self] category in
            self?.category = category
            guard let indexPath = self?.categoryIndexPath else { return }
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func scheduleTapped() {
        let vc = ScheduleViewController()
        vc.delegate = self
        vc.setSelectedDays(selectedSchedule)
        present(vc, animated: true)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        name = textField.text ?? ""
    }
}

//MARK: - UITableViewDataSource
extension NewTrackerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .options:
            return trackerType == .habit ? 2 : 1
        case .collection:
            return collectionTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
            
        case .options:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else { return UITableViewCell() }
            
            let image = UIImage(systemName: "chevron.right")
            if indexPath.row == 0 {
                cell.configure(title: "Категория", subtitle: category?.name ?? "", image: image)
                categoryIndexPath = indexPath
            } else {
                cell.configure(title: "Расписание", subtitle: scheduleSubtitle ?? "", image: image)
                scheduleIndexPath = indexPath
            }
            
            return cell
            
        case .collection:
            let type = collectionTypes[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else { return UITableViewCell() }
            cell.delegate = self
            switch type {
            case .emoji:
                cell.configure(title: "Emoji", items: EmojiLibrary.all)
            case .color:
                cell.configure(title: "Цвет", items: ColorLibrary.all)
            }
            
            return cell
        }
    }
}

extension NewTrackerViewController: OptionCollectionCellDelegate {
    func itemSelected(_ item: OptionItem) {
        switch item {
        case .emoji(_, let value):
            selectedEmoji = value
        case .color(_, let value):
            selectedColor = value
        }
    }
    
}

//MARK: - UITableViewDelegate
extension NewTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        if section == .options {
            indexPath.row == 0 ? categoryTapped() : scheduleTapped()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        
        if indexPath.section == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 60 }
        switch section {
        case .options:
            return 75
        case .collection:
            return 254
        }
    }
    
}

//MARK: - ScheduleViewControllerDelegate
extension NewTrackerViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: Set<WeekDay>) {
        guard let indexPath = scheduleIndexPath else { return }
        selectedSchedule = days
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension NewTrackerViewController: UITextFieldDelegate {
    
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
