//
//  Todos.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import Foundation

struct Task: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let description: String?
    let date: Date?
    let userId: Int
}
