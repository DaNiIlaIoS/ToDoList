//
//  TaskPresenter.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TaskPresenterProtocol: AnyObject {
    func getTask() -> Task?
    func createNewTask(title: String, text: String?)
    func updateTask(title: String, text: String?)
    func popVC()
}

final class TaskPresenter {
    weak var view: TaskViewProtocol?
    var interactor: TaskInteractorProtocol
    var router: TaskRouterProtocol
    
    init(view: TaskViewProtocol, interactor: TaskInteractorProtocol, router: TaskRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TaskPresenter: TaskPresenterProtocol {
    func getTask() -> Task? {
        interactor.task
    }
    
    func createNewTask(title: String, text: String?) {
        interactor.createNewTask(title: title, text: text)
    }
    
    func updateTask(title: String, text: String?) {
        interactor.updateTask(title: title, text: text)
    }
    
    func popVC() {
        router.popVC()
    }
}
