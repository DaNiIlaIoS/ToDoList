//
//  TaskInteractor.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TaskInteractorProtocol: AnyObject {
    var task: Task? { get }
    
    func createNewTask(title: String, text: String?)
    func updateTask(title: String, text: String?)
}

final class TaskInteractor: TaskInteractorProtocol {
    private let coreManager: CoreDataManagerProtocol
    
    weak var presenter: TaskPresenterProtocol?
    var task: Task?
    
    init(coreManager: CoreDataManagerProtocol, task: Task? = nil) {
        self.coreManager = coreManager
        self.task = task
    }
    
    func createNewTask(title: String, text: String?) {
        coreManager.createTask(title: title, text: text)
    }
    
    func updateTask(title: String, text: String?) {
        task?.updateTask(title: title, text: text)
    }
}
