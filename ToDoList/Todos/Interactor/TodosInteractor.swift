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
    
    func deleteTask(at index: Int) {
        coreManager.tasks[index].deleteTask()
        coreManager.tasks.remove(at: index)
    }
}
