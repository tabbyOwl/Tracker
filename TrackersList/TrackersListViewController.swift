//
//  TrackersListViewController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import UIKit

final class TrackersListViewController: UIViewController {
    
    private var addButton = UIButton()
    private var dateLabel = UILabel()
    private var titleLabel = UILabel()
    private var searchBar = UISearchBar()
    private var label = UILabel()
    private var imageView = UIImageView()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupBackground()
        setupAddButton()
        setupDateLabel()
        setupTitleLabel()
        setupSearchBar()
        setupImageView()
        setupLabel()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .black
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.setTitle("", for: .normal)
        view.addSubview(addButton)
    }
    
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 17, weight: .regular)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .secondarySystemBackground
        dateLabel.clipsToBounds = true
        dateLabel.layer.cornerRadius = 8
        dateLabel.text = "12.12.12"
        view.addSubview(dateLabel)
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .black
        view.addSubview(titleLabel)
    }
    
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        
        view.addSubview(searchBar)
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .dizzy)
        view.addSubview(imageView)
    }
    
    private func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        label.textAlignment = .center
        view.addSubview(label)
    }
    
   
    
    @objc private func didTapAddButton() {
        
    }
    
    private func setupConstraints() {
        let imageSide: CGFloat = 80
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.widthAnchor.constraint(equalToConstant: 343),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: imageSide),
            imageView.widthAnchor.constraint(equalToConstant: imageSide),
            imageView.heightAnchor.constraint(equalToConstant: imageSide),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
