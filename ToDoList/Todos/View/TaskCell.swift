//
//  TaskCell.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 28.08.2024.
//

import UIKit

final class TaskCell: UITableViewCell {
    // MARK: - GUI Variables
    private lazy var completedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = config
        button.addTarget(self, action: #selector(completionButtonAction), for: .touchUpInside)
        
       return button
    }()
    
    @objc func completionButtonAction() {
        toggleCompletion?()
    }
    
    private lazy var titleLabel = CustomLabel(size: .systemFont(ofSize: 19, weight: .bold), color: .black)
    private lazy var dateLabel = CustomLabel(size: .systemFont(ofSize: 14), color: .gray)
    private lazy var descriptionLabel = CustomLabel(size: .systemFont(ofSize: 14), color: .gray)
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        
        stack.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(descriptionLabel)
        
        return stack
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 5
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(hStack)
        
        return stack
    }()
    
    // MARK: - Properties
    static let reuseId = "TaskCell"
    var toggleCompletion: (() -> Void)?
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configureCell(task: Task) {
        titleLabel.text = task.title
        dateLabel.text = task.date?.formateDate()
        descriptionLabel.text = task.text
        
        completedButton.setImage(UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circlebadge"), for: .normal)
    }
    
    private func setupCell() {
        contentView.addSubview(completedButton)
        contentView.addSubview(vStack)
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            completedButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            completedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            completedButton.widthAnchor.constraint(equalToConstant: 50),
            completedButton.heightAnchor.constraint(equalToConstant: 50),
            
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            vStack.leadingAnchor.constraint(equalTo: completedButton.trailingAnchor, constant: 5),
        ])
    }
}
