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
    private let viewModel = CategoryPickerViewModel(
        store: TrackerCategoryStore()
    )

    private let stateView = StateView(
        text: "Привычки и события можно объединить по смыслу",
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
        button.setTitle("Добавить категорию", for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .projectColor(.blackDay)
        button.addTarget(
            self,
            action: #selector(createCategoryButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

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

    private func setupNavigationBar() {
        navigationItem.title = "Категория"
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
}

extension CategoryPickerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else { return UITableViewCell() }

        let title = viewModel.titleForCell(at: indexPath)
        let image = viewModel.isSelected(at: indexPath) ? UIImage(systemName: "checkmark") : nil

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
        onCategorySelected?(viewModel.category(at: indexPath))
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

