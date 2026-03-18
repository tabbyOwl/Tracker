//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/15.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let viewModel = StatisticsViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.statisticsTitle
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stateView = StateView(text: L10n.statisticsStateViewTitle, image: UIImage(resource: .statisticsStateView))
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bestStreakCard = StatisticsCardView(title: L10n.bestStreakCardTitle)
    private lazy var perfectDaysCard = StatisticsCardView(title: L10n.perfectDaysCardTitle)
    private lazy var completedTrackersCard = StatisticsCardView(title: L10n.completedTrackersCardTitle)
    private lazy var averageCard = StatisticsCardView(title: L10n.averageCardTitle)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavigationBar()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStatistics()
        updateStateView()
    }
    
    private func updateStateView() {
        let bestStreak = viewModel.getBestStreak()
        let perfectDays = viewModel.getPerfectDaysCount()
        let completedTrackersCard = viewModel.getAllCompletedTrackersCount()
        let averageCard = viewModel.getAverageCountPerDays()
        
        let hasData: Bool = (bestStreak + perfectDays + completedTrackersCard + averageCard) != 0
            
        stateView.isHidden = hasData
        stackView.isHidden = !hasData
    }
    
    private func updateStatistics() {
        bestStreakCard.update(value: "\(viewModel.getBestStreak())")
        perfectDaysCard.update(value: "\(viewModel.getPerfectDaysCount())")
        averageCard.update(value: "\(viewModel.getAverageCountPerDays())")
        completedTrackersCard.update(value: "\(viewModel.getAllCompletedTrackersCount())")
    }
    
    
    private func setupLayout() {
        view.addSubviews(stateView, titleLabel, stackView)
        stackView.addArrangedSubviews(bestStreakCard,
                                      perfectDaysCard,
                                      completedTrackersCard,
                                      averageCard)
        
        stateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            stateView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -126),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bestStreakCard.heightAnchor.constraint(equalToConstant: 90),
            perfectDaysCard.heightAnchor.constraint(equalToConstant: 90),
            completedTrackersCard.heightAnchor.constraint(equalToConstant: 90),
            averageCard.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    
    private func setupNavigationBar() {
        navigationItem.title = L10n.statisticsTitle
    }
}
