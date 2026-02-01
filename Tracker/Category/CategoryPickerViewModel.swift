//
//  CategoryPickerViewModel.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/30.
//
import UIKit

final class CategoryPickerViewModel {
    
    var isEmpty: Bool {
        categories.isEmpty
    }
    
    var numberOfRows: Int {
        categories.count
    }
    
    // MARK: - Bindings
    var onDataChanged: (() -> Void)?
    var onSelectionRestored: ((IndexPath) -> Void)?
    
    // MARK: - State
    private(set) var categories: [TrackerCategory] = []
    private(set) var selectedCategoryId: UUID?
    
    private let store: TrackerCategoryStoreProtocol
    
    // MARK: - Init
    init(store: TrackerCategoryStoreProtocol) {
        self.store = store
    }
    
    // MARK: - Data
    func loadCategories() {
        categories = store.fetchAll()
        restoreSelection()
        onDataChanged?()
    }
    
    func titleForCell(at indexPath: IndexPath) -> String {
        categories[indexPath.row].name
    }
    
    func isSelected(at indexPath: IndexPath) -> Bool {
        categories[indexPath.row].id == selectedCategoryId
    }
    
    func getCategory(at indexPath: IndexPath) -> TrackerCategory {
        categories[indexPath.row]
    }
    
    func selectCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        selectedCategoryId = category.id
        UserDefaults.standard.set(category.id.uuidString, forKey: "selectedCategoryId")
    }
    
    private func restoreSelection() {
        guard
            let idString = UserDefaults.standard.string(forKey: "selectedCategoryId"),
            let id = UUID(uuidString: idString),
            let index = categories.firstIndex(where: { $0.id == id })
        else { return }
        
        selectedCategoryId = id
        onSelectionRestored?(IndexPath(row: index, section: 0))
    }
    
    func addCategory(name: String) {
        let category = TrackerCategory(id: UUID(), name: name, trackers: [])
        store.addCategory(id: category.id, name: category.name)
        categories.append(category)
        onDataChanged?()
    }
    
    func updateCategory(_ category: TrackerCategory) {
        store.updateCategory(id: category.id, newName: category.name)
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            onDataChanged?()
        }
    }
    
    func deleteCategory(by id: UUID) {
        if let index = categories.firstIndex(where: { $0.id == id }) {
            store.deleteCategory(id: id)
            categories.remove(at: index)
            onDataChanged?()
        }
    }
    
}
