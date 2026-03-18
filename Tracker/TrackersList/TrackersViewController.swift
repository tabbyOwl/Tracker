//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import UIKit

final class TrackersViewController: UIViewController {
    
    private let viewModel =  TrackersViewModel()
    
    // MARK: - UI
    private lazy var stateView = StateView(text: L10n.trackersStateViewTitle, image: UIImage(resource: .dizzy))
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.trackersTitle
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = L10n.searchPlaceholder
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.filterButton, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .projectColor(.blue)
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        bindViewModel()
        viewModel.loadCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsService.report(
            event: "open",
            screen: "Main"
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent || self.isBeingDismissed {
            AnalyticsService.report(
                event: "close",
                screen: "Main"
            )
        }
    }
    
    private func setTodayDate() {
        let today = Date()
        datePicker.setDate(today, animated: true)
        datePickerValueChanged(datePicker)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        
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
        view.addSubviews(titleLabel,
                         searchBar,
                         collectionView,
                         stateView,
                         filterButton)
        
        
        stateView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonHeight: CGFloat = 50
        let buttonBottom: CGFloat = 16
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: buttonHeight + buttonBottom + 8, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        
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
            stateView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -buttonBottom),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    private func updateState() {
        let isEmpty = viewModel.isEmpty
        stateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            self?.collectionView.reloadData()
            self?.updateState()
        }
        
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }
    
    private func render(_ state: TrackersState) {
        switch state {
        case .content:
            collectionView.isHidden = false
            stateView.isHidden = true
            filterButton.isHidden = false
        case .emptyTrackers:
            collectionView.isHidden = true
            stateView.isHidden = false
            filterButton.isHidden = true
            
            stateView.configure(
                text: L10n.trackersStateViewTitle,
                image: UIImage(resource: .dizzy)
            )
            
        case .emptyFilter:
            collectionView.isHidden = true
            stateView.isHidden = false
            filterButton.isHidden = false
            
            stateView.configure(
                text: L10n.trackersStateViewEmptyFilter,
                image: UIImage(resource: .filterStateView)
            )
        }
    }
    
    // MARK: - Actions
    @objc private func didTapAddButton() {
        AnalyticsService.report(
            event: "click",
            screen: "Main",
            item: "add_track"
        )
        
        let chooseVC = TrackerTypePickerViewController()
        
        chooseVC.onCreateTracker = { [weak self] tracker in
            guard let self else { return }
            viewModel.saveTracker(tracker: tracker)
        }
        
        let nav = UINavigationController(rootViewController: chooseVC)
        present(nav, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        viewModel.setSelectedDate(sender.date)
        viewModel.reloadCompletedTrackers()
        viewModel.updateFilteredCategories()
    }
    
    @objc func textDidChange(_ searchField: UISearchTextField) {
        let text = searchField.text ?? ""
        viewModel.setSearchText(text)
    }
    
    @objc private func didTapFilterButton() {
        
        AnalyticsService.report(
            event: "click",
            screen: "Main",
            item: "filter"
        )
        
        let vc = FilterViewController()
        vc.selectedFilter = viewModel.getFilter()
        
        vc.onFilterSelected = { [weak self] filter in
            if filter == .today {
                self?.setTodayDate()
            }
            
            self?.viewModel.setFilter(filter)
            self?.updateFilterButton(filter)
        }
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    private func updateFilterButton(_ filter: FilterType) {
        filterButton.setTitleColor(filter.isActive ? .systemRed : .white,for: .normal)
    }
    
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getTrackersCount(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCardCell.reuseIdentifier, for: indexPath) as? TrackerCardCell else { return UICollectionViewCell() }
        let tracker = viewModel.getTrackerForCell(section: indexPath.section, item: indexPath.item)
        cell.delegate = self
        
        let isCompleted = viewModel.isCompleted(for: tracker.id)
        let completedDaysCount = viewModel.getCompletedDaysCount(for: tracker.id)
        
        cell.configure(with: tracker, isCompleted: isCompleted, completedDaysCount: completedDaysCount, indexPath: indexPath)
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
            let title = viewModel.getTitle(for: indexPath.section)
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
        
        CGSize(width: (collectionView.bounds.width - 8) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
}

//MARK: - TrackerCardCellDelegate

extension TrackersViewController: TrackerCardCellDelegate {
    func didPinItem(at indexPath: IndexPath) {
        let tracker = viewModel.getTrackerForCell(section: indexPath.section, item: indexPath.item)
        viewModel.togglePin(for: tracker.id)
    }
    
    func didDeleteItem(at indexPath: IndexPath) {
        let tracker = viewModel.getTrackerForCell(section: indexPath.section, item: indexPath.item)
        viewModel.deleteTracker(byId: tracker.id)
    }
    
    func didEditItem(at indexPath: IndexPath) {
        let tracker = viewModel.getTrackerForCell(section: indexPath.section, item: indexPath.item)
        guard let category = viewModel.getCategory(by: tracker.categoryId) else { return }
        
        let trackerFormVC = TrackerFormViewController(mode: .edit(tracker: tracker, category: category))
        
        trackerFormVC.onSaveTracker = { [weak self] tracker in
            self?.viewModel.updateTracker(tracker: tracker)
        }
        present(UINavigationController(rootViewController: trackerFormVC), animated: true)
    }
    
    func actionButtonTapped(_ cell: TrackerCardCell) {
        guard !viewModel.isFutureDate else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        AnalyticsService.report(
            event: "click",
            screen: "Main",
            item: "track"
        )
        
        let tracker = viewModel.getTrackerForCell(section: indexPath.section, item: indexPath.item)
        
        viewModel.toggleRecords(for: tracker.id)
        viewModel.reloadCompletedTrackers()
        collectionView.reloadItems(at: [indexPath])
    }
}
