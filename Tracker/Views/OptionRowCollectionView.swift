//
//  OptionRowCollectionView.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/17.
//
import UIKit

protocol OptionRowCollectionViewDelegate: AnyObject {
    func itemSelected(_ item: OptionItem)
}

final class OptionRowCollectionView: UIView {
    
    weak var delegate: OptionRowCollectionViewDelegate?
    
    // MARK: - Private
    private let titleLabel = UILabel()
    private let collectionView: UICollectionView
    private var items: [OptionItem] = []
    
    private var selectedItem: OptionItem?
    
    // MARK: - Init
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 52, height: 52)
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        super.init(frame: .zero)
        
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
        setupCollectionView()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func updateItems(title: String, items: [OptionItem]) {
        self.items = items
        self.titleLabel.text = title
        collectionView.reloadData()
    }
    
    // MARK: - Layout
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension OptionRowCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else { return UICollectionViewCell() }
        
        let item = items[indexPath.item]
        cell.configure(with: item, isSelected: item == selectedItem)
        
        return cell
    }
}

extension OptionRowCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selectedItem = item
        collectionView.reloadData()
        delegate?.itemSelected(item)
    }
}

extension OptionRowCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 6
        let spacing: CGFloat = 5
        
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        let itemWidth = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            5
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
}
