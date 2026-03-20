//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/15.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let viewModel = StatisticsViewModel()
    private var statisticsCards: [StatisticsCardView] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCards()
        setupLayout()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateStatistics()
        updateStateView()
    }
    
    private func setupView() {
        navigationItem.title = L10n.statisticsTitle
        view.backgroundColor = .systemBackground
    }
    
    private func setupCards() {
        statisticsCards = viewModel.getStatisticsCards()
    }
    
    private func updateStateView() {
        let hasData = viewModel.hasData()
        
        stateView.isHidden = hasData
        stackView.isHidden = !hasData
    }
    
    private func updateStatistics() {
        let statisticsValues = viewModel.getStatisticsValues()
        
        for (index, card) in statisticsCards.enumerated() {
            card.update(value: "\(statisticsValues[index])")
        }
    }
    
    private func setupLayout() {
        view.addSubviews(stateView, titleLabel, stackView)
        
        statisticsCards.forEach {
            stackView.addArrangedSubview($0)
            
            NSLayoutConstraint.activate( [
                $0.heightAnchor.constraint(equalToConstant: 90)
            ])
        }
        
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
        ])
    }
}
