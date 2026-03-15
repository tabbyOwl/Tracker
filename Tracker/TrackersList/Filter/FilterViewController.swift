//
//  FilterViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/5.
//

import UIKit

final class FilterViewController: UIViewController {
    
    var onFilterSelected: ((FilterType) -> Void)?
    var selectedFilter: FilterType = .all
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        table.separatorStyle = .singleLine
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = L10n.filterTitle
    }
    
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FilterType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else { return UITableViewCell() }
        
        
        let filter = FilterType.allCases[indexPath.row]
        
        let shouldShowCheckmark = isSelected(at: indexPath) && ![FilterType.all, .today].contains(filter)
        
        let title = filter.title
        let image = shouldShowCheckmark ? UIImage(systemName: "checkmark") : nil
        
        cell.configure(title: title, image: image)
        
        return cell
    }
    
    private func isSelected(at indexPath: IndexPath) -> Bool {
        FilterType.allCases[indexPath.row] == selectedFilter
    }
    
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let previousFilter = selectedFilter
        selectedFilter = FilterType.allCases[indexPath.row]
        let previousIndex = FilterType.allCases.firstIndex(of: previousFilter)

        var toReload = [indexPath]

        if let previousIndex {
            toReload.append(IndexPath(row: previousIndex, section: 0))
        }

        tableView.reloadRows(at: toReload, with: .automatic)

        onFilterSelected?(selectedFilter)

        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
