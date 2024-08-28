//
//  Date+Ex.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 28.08.2024.
//

import Foundation

extension Date {
    func formateDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: self)
    }
}
