//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

final class TaskViewController: UIViewController {
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = placeholder
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
    
    private lazy var saveAction = UIAction { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
    }
    
    private lazy var updateAction = UIAction { [weak self] _ in

    }
    
    var placeholder = "Write description for note"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUIForNote()
        
        descriptionTextView.delegate = self
    }
    
    private func configureUIForNote() {

    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
//        view.addSubview(updateButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
//        let button = presenter.note == nil ? saveButton : updateButton
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
        ])
    }
}

extension TaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Текст"
            textView.textColor = UIColor.lightGray
        }
    }
}