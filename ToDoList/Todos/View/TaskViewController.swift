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
        textField.placeholder = "Title"
        textField.autocapitalizationType = .sentences
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.text = "Write description for note"
        textView.autocapitalizationType = .sentences
        textView.textColor = .systemGray3
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var saveButton = CustomButton(title: "Сохранить", action: saveAction)
    private lazy var updateButton = CustomButton(title: "Обновить", action: updateAction)
    
    // MARK: - Properties
    var presenter: TaskPresenterProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configTask()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private lazy var saveAction = UIAction { [weak self] _ in
        guard let title = self?.titleTextField.text, !title.isEmpty else { return }
        
        self?.presenter?.createNewTask(title: title, text: self?.descriptionTextView.text)
        self?.presenter?.popVC()
    }
    
    private lazy var updateAction = UIAction { [weak self] _ in
        guard let title = self?.titleTextField.text, !title.isEmpty else { return }
        
        self?.presenter?.updateTask(title: title, text: self?.descriptionTextView.text)
        self?.presenter?.popVC()
    }
    
    private func configTask() {
        guard let task = presenter?.getTask() else {
            updateButton.isHidden = true
            return
        }
        titleTextField.text = task.title
        
        descriptionTextView.text = task.text
        descriptionTextView.textColor = .label
        
        saveButton.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        view.addSubview(updateButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let button = presenter?.getTask() == nil ? saveButton : updateButton
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            button.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionTextView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
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

extension TaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write description for note"
            textView.textColor = UIColor.systemGray3
        }
    }
}
