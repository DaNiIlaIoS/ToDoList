//
//  CustomLabel.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 28.08.2024.
//

import UIKit

final class CustomLabel: UILabel {
    var size: UIFont
    var color: UIColor
    
    init(size: UIFont, color: UIColor = .label) {
        self.size = size
        self.color = color
        
        super.init(frame: .zero)
        createLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel() {
        self.font = size
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
