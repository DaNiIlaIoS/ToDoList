//
//  TodosPresenter.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TodosPresenterProtocol: AnyObject {
    var allTasks: [Task] { get set }
    var filteredTasks: [Task] { get set }
    var isSearching: Bool { get set }
    
    func viewDidLoaded()
    func deleteTask(at indexPath: IndexPath)
    func showTaskVC(task: Task?)
    func task(at index: Int) -> Task
    func fetchTasks()
    func searchTasks(with text: String)
}

final class TodosPresenter {
    weak var view: TodosViewProtocol?
    var interactor: TodosInteractorProtocol
    var router: TodosRouterProtocol
    
    var allTasks: [Task] = [] {
        didSet {
            view?.updateBottomBarCount()
        }
    }
    var filteredTasks: [Task] = []
    var isSearching: Bool = false
    
    init(view: TodosViewProtocol, interactor: TodosInteractorProtocol, router: TodosRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension TodosPresenter: TodosPresenterProtocol {
    func viewDidLoaded() {
        interactor.getTasks()
        fetchTasks()
        view?.reloadData()
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let index = indexPath.row
        let task = filteredTasks[index]
        
        if let filteredIndex = filteredTasks.firstIndex(of: task) {
            filteredTasks.remove(at: filteredIndex)
        }
        
        interactor.deleteTask(at: indexPath.row)
    }
    
    func showTaskVC(task: Task?) {
        router.openTaskVC(task: task)
    }
    
    func task(at index: Int) -> Task {
        return filteredTasks[index]
    }
    
    func fetchTasks() {
        allTasks = interactor.coreManager.tasks
        filteredTasks = allTasks
        view?.reloadData()
    }
    
    func searchTasks(with text: String) {
        filteredTasks = interactor.searchTasks(with: text)
        view?.reloadData()
    }
}
