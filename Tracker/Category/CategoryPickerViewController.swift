//
//  CategoryPickerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/28.
//
import UIKit

final class CategoryPickerViewController: UIViewController {
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - Public
    private var categories: [TrackerCategory] = []
    private let stateView = StateView(text: "Привычки и события можно объединить по смыслу",
                                      image: UIImage(resource: .dizzy))
    
    private var selectedIndexPath: IndexPath?
    private var selectedCategoryId: UUID?
    private let fetchedController = TrackerCategoryFetchedController()
    private let categoryStore = TrackerCategoryStore()
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
          let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
          gesture.minimumPressDuration = 1.0
          return gesture
      }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .projectColor(.blackDay)
        return button
        
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
        restoreSelection()
        setupUI()
        setupNavigationBar()
        updateStateView()
    }
  
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
        tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        createCategoryButton.addTarget(self, action: #selector(createCategoryButtonTaped), for: .touchUpInside)
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
    
    private func fetchCategories() {
        fetchedController.onChange = { [weak self] in
            self?.categories = self?.fetchedController.categories() ?? []
        }
        
        categories = fetchedController.categories()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Категория"
    }
    
    private func updateStateView() {
        let isEmpty = categories.isEmpty
        stateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func restoreSelection() {
        guard let selectedCategoryId = getSelectedCategoryId() else { return }
        
        if let index = categories.firstIndex(where: { $0.id == selectedCategoryId }) {
            self.selectedIndexPath = IndexPath(row: index, section: 0)
        } else {
            self.selectedIndexPath = nil
        }
    }
    
    func getSelectedCategoryId() -> UUID? {
        guard
            let idString = UserDefaults.standard.string(forKey: "selectedCategoryId"),
            let uuid = UUID(uuidString: idString)
        else {
            return nil
        }
        
        return uuid
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            let point = gesture.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: point), gesture.state == .began else { return }
            
            let category = categories[indexPath.row]
            
            let actionSheet = UIAlertController(title: "Выберите действие", message: nil, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { _ in
                self.presentEditCategory(category)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.showDeleteConfirmation(for: category)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            
            present(actionSheet, animated: true)
        }
    
    private func presentEditCategory(_ category: TrackerCategory) {
            let editVC = EditCategoryViewController(category: category)
        
        editVC.onCategoryUpdated = { [weak self] updatedCategory in
            guard let self else { return }

            if let index = self.categories.firstIndex(where: { $0.id == updatedCategory.id }) {
                self.categories[index] = updatedCategory
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }

            self.categoryStore.updateCategory(
                id: updatedCategory.id,
                newName: updatedCategory.name
            )
        }
            let nav = UINavigationController(rootViewController: editVC)
            present(nav, animated: true)
        }
        
        // MARK: - Delete Category
        private func showDeleteConfirmation(for category: TrackerCategory) {
            let alertController = UIAlertController(title: "Подтвердите удаление", message: "Вы уверены, что хотите удалить категорию?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.deleteCategory(category)
            }))
            
            alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            
            present(alertController, animated: true)
        }
        
        private func deleteCategory(_ category: TrackerCategory) {
            categoryStore.deleteCategory(id: category.id)
            categories.removeAll { $0.id == category.id }
            tableView.reloadData()
            updateStateView()
        }
    
    @objc private func createCategoryButtonTaped() {
        let vc = NewCategoryViewController()
        vc.onCategoryCreated = { [weak self] name in
            let category = TrackerCategory(id: UUID(), name: name, trackers: [])
            self?.categories.append(category)
            self?.tableView.reloadData()
            self?.updateStateView()
            self?.categoryStore.addCategory(id: category.id, name: category.name)
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CategoryPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else { return UITableViewCell() }
        
        let category = categories[indexPath.row]
        
        var image: UIImage? = nil
        if indexPath == selectedIndexPath {
            image = UIImage(systemName: "checkmark")        }
        cell.configure(title: category.name, image: image)
        
        return cell
    }
}


//MARK: - UITableViewDelegate
extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let previousIndexPath = selectedIndexPath
        
        selectedIndexPath = indexPath
        
        var indexPathsToReload = [indexPath]
        if let previous = previousIndexPath {
            indexPathsToReload.append(previous)
        }
        
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        
        let category = categories[indexPath.row]
        onCategorySelected?(category)
        UserDefaults.standard.set(category.id.uuidString, forKey: "selectedCategoryId")
        dismiss(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

