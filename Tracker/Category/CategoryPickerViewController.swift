//
//  CategoryPickerViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/28.
//
import UIKit

final class CategoryPickerViewController: UIViewController {
    
    // MARK: - Public
    private var categories: [TrackerCategory] = []
    
    private let stateView = StateView(text: "Привычки и события можно объединить по смыслу",
                                      image: UIImage(resource: .dizzy))
    
    private let fetchedController = TrackerCategoryFetchedController()
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .singleLine
        return tableView
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
        tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        setupUI()
        setupNavigationBar()
        updateStateView()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
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
        
    }

//MARK: - UITableViewDataSource
extension CategoryPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else { return UITableViewCell() }
        
        return cell
    }
}


//MARK: - UITableViewDelegate
extension CategoryPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

