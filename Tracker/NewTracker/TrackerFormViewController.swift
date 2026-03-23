//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

enum TrackerFormMode {
    case create(type: TrackerType)
    case edit(tracker: Tracker, category: TrackerCategory)
}

final class TrackerFormViewController: UIViewController {
    
    var onSaveTracker: ((Tracker) -> Void)?
    
    private let mode: TrackerFormMode
    private let viewModel: TrackerFormViewModel
    private let textField = TextFieldView(placeholder: L10n.NewTracker.placeholder)
    
    // MARK: - Sections
    private enum Section: Int, CaseIterable {
        case options
        case collection
    }
    
    private enum CollectionType {
        case emoji
        case color
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
    
    private var footerView = TrackerFooterView()
    
    // MARK: - Init
    init(mode: TrackerFormMode) {
        self.mode = mode
        self.viewModel = TrackerFormViewModel(mode: mode)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.validateForm()
        setupTextField()
        setupUI()
        setupNavigationBar()
        registerCells()
        setupFooter()
        setupInitialValues()
    }
    
    private func setupUI() {
        view.backgroundColor = .appWhite
        tableView.backgroundColor = .appWhite
        
        view.addSubviews(textField, tableView)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
        ])
    }
    
    private func setupTextField() {
        textField.onTextChanged = { [weak self] text in
            self?.viewModel.setName(text)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.navigationTitle
    }
    
    private func registerCells() {
        tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        tableView.register(CollectionCell.self, forCellReuseIdentifier: CollectionCell.identifier)
    }
    
    private func setupInitialValues() {
        textField.text = viewModel.getName()
    }
    
    private func setupFooter() {
        footerView = TrackerFooterView(mode: mode)
        footerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 120)
        footerView.onCancel = { [weak self] in
            self?.cancel()
        }
        
        footerView.onCreate = { [weak self] in
            self?.saveTracker()
        }
        
        tableView.tableFooterView = footerView
    }
    
    private func cancel() {
        switch mode {
        case .create:
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case .edit:
            dismiss(animated: true)
        }
    }
    
    private func saveTracker() {
        guard let tracker = viewModel.saveTracker() else { return }

        switch mode {
        case .create:
            onSaveTracker?(tracker)
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case .edit:
            onSaveTracker?(tracker)
            dismiss(animated: true)
        }

      
    }
  
    
    private func categoryTapped() {
        let vc = CategoryPickerViewController()
        vc.onCategorySelected = { [weak self] category in
            self?.viewModel.setSelectedCategory(category)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    private func scheduleTapped() {
        let vc = ScheduleViewController()
        vc.delegate = self
        
        vc.setSelectedDays(viewModel.getSchedule())
        present(vc, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.onCreateButtonStateChanged = { [weak self] isEnabled in
            self?.footerView.setCreateButtonState(isEnabled)
        }
        
        viewModel.onCategoryChanged = { [weak self] in
            let indexPath = IndexPath(row: 0, section: Section.options.rawValue)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        viewModel.onScheduleChanged = { [weak self] _ in
            let indexPath = IndexPath(row: 1, section: Section.options.rawValue)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.setName(textField.text ?? "")
    }
}

//MARK: - UITableViewDataSource
extension TrackerFormViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .options:
            let trackerType = viewModel.getTrackerType()
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
                let categoryName = viewModel.getCategoryName()
                cell.configure(title: L10n.Common.categoryTitle, subtitle: categoryName, image: image)
            } else {
                let scheduleSubtitle = viewModel.scheduleSubtitle
                cell.configure(title: L10n.Common.scheduleTitle, subtitle: scheduleSubtitle, image: image)
            }
            
            return cell
            
        case .collection:
            let type = collectionTypes[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionCell.identifier, for: indexPath) as? CollectionCell else { return UITableViewCell() }
            cell.delegate = self
            switch type {
            case .emoji:
                cell.configure(title: L10n.Common.emojiTitle, items: EmojiLibrary.all, selectedItem: viewModel.getSelectedEmojiItem())
            case .color:
                cell.configure(title: L10n.Common.colorTitle, items: ColorLibrary.all, selectedItem: viewModel.getSelectedColorItem())
            }
            
            return cell
        }
    }
}

//MARK: - OptionCollectionCellDelegate
extension TrackerFormViewController: OptionCollectionCellDelegate {
    
    func itemSelected(_ item: OptionItem) {
        switch item {
        case .emoji(_, let value):
            viewModel.setSelectedEmoji(value)
        case .color(_, let value):
            viewModel.setSelectedColor(value)
        }
    }
}

//MARK: - UITableViewDelegate
extension TrackerFormViewController: UITableViewDelegate {
    
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
extension TrackerFormViewController: ScheduleViewControllerDelegate {
    
    func didSelectDays(_ days: Set<WeekDay>) {
        viewModel.setSchedule(days)
    }
}
