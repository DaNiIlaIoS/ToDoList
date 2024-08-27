//
//  CustomButton.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

final class CustomButton: UIButton {
    var title: String
    var action: UIAction
    
    init(title: String, action: UIAction) {
        self.title = title
        self.action = action
        
        super.init(frame: .zero)
        createBigButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBigButton() {
        self.addAction(action, for: .touchUpInside)
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
