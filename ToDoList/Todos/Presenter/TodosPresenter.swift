//
//  TodosPresenter.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TodosPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didFetchTasks() -> [Task]
    func deleteTask(at indexPath: IndexPath)
    func reloadData()
    func showTaskVC(task: Task?)
}

final class TodosPresenter {
    weak var view: TodosViewProtocol?
    var interactor: TodosInteractorProtocol
    var router: TodosRouterProtocol
    
    init(view: TodosViewProtocol, interactor: TodosInteractorProtocol, router: TodosRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TodosPresenter: TodosPresenterProtocol {
    func viewDidLoaded() {
        interactor.getTasks()
    }
    func didFetchTasks() -> [Task] {
        return interactor.coreManager.tasks
    }
    
    func deleteTask(at indexPath: IndexPath) {
        interactor.deleteTask(at: indexPath.row)
    }
    
    func reloadData() {
        view?.reloadData()
    }
    
    func showTaskVC(task: Task?) {
        router.openTaskVC(task: task)
    }

}
