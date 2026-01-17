//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/13.
//
import UIKit

final class ScheduleCell: UITableViewCell {
    static let reuseIdentifier = "ScheduleCell"
    var onSwitchChanged: ((Bool) -> Void)?
    
    //MARK: -Private properties
    private let dayLabel = UILabel()
    private let toggle = UISwitch()
    
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Private methods
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .projectColor(.backgroundDay)
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(toggle)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        toggle.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc private func switchChanged() {
        onSwitchChanged?(toggle.isOn)
    }
    
    // MARK: - Public methods
    func configure(title: String, isOn: Bool) {
        dayLabel.text = title
        toggle.onTintColor = .systemBlue
        toggle.isOn = isOn
    }
}
