//
//  CategoryPickerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/28.
//
import UIKit

final class CategoryPickerViewController: UIViewController {
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    private(set) var selectedIndexPath: IndexPath?
    private let viewModel: CategoryPickerViewModel
    
    private let stateView = StateView(
        text: L10n.CategoryPicker.stateText,
        image: UIImage(resource: .dizzy)
    )
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        table.separatorStyle = .singleLine
        return table
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.CategoryPicker.addButton, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .appBlack
        button.addTarget(
            self,
            action: #selector(createCategoryButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    init(viewModel: CategoryPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        bindViewModel()
        viewModel.loadCategories()
    }
    
    // MARK: - UI
    private func setupUI() {
        view.backgroundColor = .appWhite
        tableView.backgroundColor = .appWhite
        
        view.addSubviews(stateView, tableView, createCategoryButton)
        
        stateView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        createCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .appWhite
        navigationItem.title = L10n.CategoryPicker.title
    }
    
    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            self?.updateStateView()
            self?.tableView.reloadData()
        }
    }
    
    private func updateStateView() {
        let isEmpty = viewModel.isEmpty
        stateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    @objc private func createCategoryButtonTapped() {
        let vc = NewCategoryViewController()
        vc.onCategoryCreated = { [weak self] name in
            self?.viewModel.addCategory(name: name)
        }
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func showEditView(for category: TrackerCategory) {
        let editVC = EditCategoryViewController(category: category)
        
        editVC.onCategoryUpdated = { [weak self] category in
            self?.viewModel.updateCategory(category)
        }
        
        let navController = UINavigationController(rootViewController: editVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true, completion: nil)
    }
    
    private func deleteCategory(_ category: TrackerCategory) {
        let title = L10n.CategoryPicker.deleteTitle
        let message = L10n.CategoryPicker.deleteMessage
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: L10n.Common.cancel, style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: L10n.Common.delete, style: .destructive, handler: { _ in
            self.viewModel.deleteCategory(by: category.id)
        }))
        
        present(alertController, animated: true)
    }
}

extension CategoryPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else { return UITableViewCell() }
        
        let title = viewModel.titleForCell(at: indexPath)
        let image = viewModel.isSelected(at: indexPath) ? SystemImage.checkmark : nil
        cell.configure(title: title, image: image)
        
        return cell
    }
    
}

extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previous = selectedIndexPath
        selectedIndexPath = indexPath
        
        var toReload = [indexPath]
        if let previous { toReload.append(previous) }
        
        tableView.reloadRows(at: toReload, with: .automatic)
        
        viewModel.selectCategory(at: indexPath)
        onCategorySelected?(viewModel.getCategory(at: indexPath))
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let category = viewModel.getCategory(at: indexPath)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(
                title: L10n.Common.edit,
                image: SystemImage.pencil
            ) { _ in
                self.showEditView(for: category)
            }
            
            let deleteAction = UIAction(
                title: L10n.Common.delete,
                image: SystemImage.trash,
                attributes: .destructive
            ) { _ in
                self.deleteCategory(category)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}


