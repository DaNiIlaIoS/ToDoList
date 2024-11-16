//
//  BottomBarView.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 14.11.2024.
//

import UIKit

final class BottomBarView: UIView {
    // MARK: - UI Elements
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        addSubview(countLabel)
        addSubview(addButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Actions
    func updateCount(_ count: Int) {
        countLabel.text = "\(count) заметок"
    }
}
