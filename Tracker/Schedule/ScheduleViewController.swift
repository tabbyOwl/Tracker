//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectDays(_ days: Set<WeekDay>)
}

final class ScheduleViewController: UIViewController {
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Private properties
    private var selectedDays: Set<WeekDay> = []
    
    private let orderedWeekDays = WeekDay.allCases.sorted {
        $0.displayOrder < $1.displayOrder
    }
    
    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
    }
    
    func setSelectedDays(_ days: Set<WeekDay> ) {
        selectedDays = days
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        title = "Расписание"
        
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func doneTapped() {
        delegate?.didSelectDays(selectedDays)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderedWeekDays.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }
        
        let day = orderedWeekDays[indexPath.row]
        cell.configure(title: day.title, isOn: selectedDays.contains(day))
        
        cell.onSwitchChanged = { [weak self] isOn in
            if isOn {
                self?.selectedDays.insert(day)
            } else {
                self?.selectedDays.remove(day)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
