//
//  TodosInteractor.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TodosInteractorProtocol: AnyObject {
    var coreManager: CoreDataManagerProtocol { get }
    
    func getTasks()
    func searchTasks(with text: String) -> [Task]
    func deleteTask(at index: Int)
}

final class TodosInteractor: TodosInteractorProtocol {
    private let networkManager: NetworkManagerProtocol
    var coreManager: CoreDataManagerProtocol
    
    weak var presenter: TodosPresenterProtocol?
    
    init(networkManager: NetworkManagerProtocol, coreManager: CoreDataManagerProtocol) {
        self.networkManager = networkManager
        self.coreManager = coreManager
    }
    
    func getTasks() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            networkManager.getTodos { [weak self] result in
                switch result {
                case .success(let tasks):
                    DispatchQueue.main.async {
                        self?.coreManager.saveApiTasks(tasks)  
                        self?.presenter?.fetchTasks()
                        
                        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            coreManager.fetchTask()
        }
    }
    
    func searchTasks(with text: String) -> [Task] {
        let searchText = text.lowercased()
        
        if text.isEmpty {
            return coreManager.tasks
        } else {
            return coreManager.tasks.filter { task in
                let titleContainsText = task.title?.lowercased().contains(searchText) ?? false
                let descriptionContainsText = task.text?.lowercased().contains(searchText) ?? false
                return titleContainsText || descriptionContainsText
            }
        }
    }
    
    func deleteTask(at index: Int) {
        coreManager.tasks[index].deleteTask()
        coreManager.tasks.remove(at: index)
    }
}
