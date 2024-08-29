//
//  TaskCellInteractor.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TaskCellInteractorProtocol: AnyObject {
    var taskData: Task { get }
    
    func toggleCompletion()
}

final class TaskCellInteractor: TaskCellInteractorProtocol {
    var taskData: Task
    
    weak var presenter: TaskCellPresenterProtocol?
    
    init(taskData: Task) {
        self.taskData = taskData
    }
    
    func toggleCompletion() {
        taskData.toggleCompleted()
    }
}
