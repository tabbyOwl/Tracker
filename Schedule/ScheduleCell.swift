//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/13.
//
import UIKit

final class ScheduleCell: UITableViewCell {
    
    static let reuseIdentifier = "ScheduleCell"
    
    private let dayLabel = UILabel()
    private let toggle = UISwitch()
    
    var onSwitchChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        
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
    
    func configure(title: String, isOn: Bool) {
        dayLabel.text = title
        toggle.isOn = isOn
    }
    
    @objc private func switchChanged() {
        onSwitchChanged?(toggle.isOn)
    }
}
