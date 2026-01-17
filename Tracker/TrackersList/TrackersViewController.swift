//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private properties
    private var categories: [TrackerCategory] = [] {
        didSet {
            updateFilteredCategories()
            collectionView.reloadData()
            updateState()
        }
    }
    
    private var selectedDate: Date = Date()
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    // MARK: - UI
    private let stateView = StateView()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        updateFilteredCategories()
        updateState()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(stateView)
        
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupCollectionView() {
        collectionView.register(TrackerCardCell.self, forCellWithReuseIdentifier: TrackerCardCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        
        stateView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stateView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
            
        ])
    }
    
    private func updateFilteredCategories() {
        guard let selectedWeekday = WeekDay(date: selectedDate) else { return }

        filteredCategories = categories
            .map { category in
                let trackers = category.trackers.filter { tracker in
                    tracker.schedule.isEmpty || tracker.schedule.contains(selectedWeekday)
                }
                return TrackerCategory(
                    id: category.id,
                    name: category.name,
                    trackers: trackers
                )
            }
            .filter { !$0.trackers.isEmpty }
    }
    
    private func updateState() {
        let isEmpty = filteredCategories.isEmpty
        stateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    // MARK: - Actions
    @objc private func didTapAddButton() {
        let chooseVC = ChooseTrackerTypeViewController()
        
        chooseVC.onCreateTracker = { [weak self] draft in
            guard let self else { return }
            
            let tracker = Tracker(
                id: UUID(),
                name: draft.name,
                color: .gray,
                emoji: "🍎",
                schedule: draft.schedule
            )
            
            self.addTracker(tracker, to: draft.categoryId)
        }
        
        let nav = UINavigationController(rootViewController: chooseVC)
        present(nav, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateFilteredCategories()
        collectionView.reloadData()
        updateState()
    }
    
    private func addTracker(_ tracker: Tracker, to categoryId: UUID) {
        if let index = categories.firstIndex(where: { $0.id == categoryId }) {
            let oldCategory = categories[index]
            
            let updatedCategory = TrackerCategory(id: oldCategory.id, name: oldCategory.name, trackers: oldCategory.trackers + [tracker])
            
            categories[index] = updatedCategory
        } else {
            let newCategory = TrackerCategory(id: categoryId, name: "Дом", trackers: [tracker])
            categories.append(newCategory)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCardCell.reuseIdentifier, for: indexPath) as? TrackerCardCell else { return UICollectionViewCell() }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        cell.delegate = self
        let markedDates = completedTrackers
            .filter { $0.id == tracker.id }
            .map { $0.date }
        
        cell.configure(with: tracker, markedDates: Set(markedDates), for: selectedDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? SectionHeaderView else {
                return UICollectionReusableView()
            }
            let title = filteredCategories[indexPath.section].name
            header.configure(title: title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width - 8) / 2, height: 148
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

//MARK: - TrackerCardCellDelegate

extension TrackersViewController: TrackerCardCellDelegate {
    func actionButtonTapped(_ cell: TrackerCardCell) {
        let currentDate = Date()
        if selectedDate > currentDate {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let day = Calendar.current.startOfDay(for: selectedDate)
        let record = TrackerRecord(id: tracker.id, date: day)
        
        if completedTrackers.contains(record) {
            completedTrackers.remove(record)
        } else {
            completedTrackers.insert(record)
        }
        
        let markedDates = completedTrackers
            .filter { $0.id == tracker.id }
            .map { $0.date }
        
        cell.configure(with: tracker, markedDates: Set(markedDates), for: selectedDate)
    }
}
