//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

protocol TaskViewProtocol: AnyObject {
    
}

final class TaskViewController: UIViewController, TaskViewProtocol {
    // MARK: - GUI Variables
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .sentences
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.delegate = self
        return textField
    }()
    
    private lazy var dateLabel = CustomLabel(size: .systemFont(ofSize: 12), color: .gray)
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.autocapitalizationType = .sentences
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    // MARK: - Properties
    var presenter: TaskPresenterProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configTask()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        saveAction()
    }
    
    // MARK: - Methods    
    func saveAction() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        
        let body = descriptionTextView.text
        if let _ = presenter?.getTask() {
            presenter?.updateTask(title: title, text: body)
        } else {
            presenter?.createNewTask(title: title, text: body)
        }
    }
    
    
    
    private func configTask() {
        guard let task = presenter?.getTask() else { return }
        
        titleTextField.text = task.title
        dateLabel.text = task.date?.formateDate()
        descriptionTextView.text = task.text
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
        navigationController?.navigationBar.prefersLargeTitles = false
        
        dateLabel.text = Date.now.formateDate()
        titleTextField.becomeFirstResponder()
        
        hideKeyboardWhenTapped()
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
        ])
    }
}

extension TaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTextField.isFirstResponder {
            descriptionTextView.becomeFirstResponder()
        }
        return true
    }
}
