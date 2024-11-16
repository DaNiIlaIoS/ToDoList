//
//  UIViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 16.11.2024.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
