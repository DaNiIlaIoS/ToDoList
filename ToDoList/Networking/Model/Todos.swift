//
//  Todos.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import Foundation

struct Todos: Decodable {
    let todos: [ApiTask]
}
