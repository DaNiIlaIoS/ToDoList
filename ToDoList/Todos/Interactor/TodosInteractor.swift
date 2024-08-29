//
//  TodosInteractor.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TodosInteractorProtocol: AnyObject {
    var coreManager: CoreDataManager { get }
    
    func getTasks()
    func deleteTask(at index: Int)
}

final class TodosInteractor: TodosInteractorProtocol {
    private let networkManager = NetworkManager()
    let coreManager = CoreDataManager.shared
    
    weak var presenter: TodosPresenterProtocol?

    func getTasks() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            networkManager.getTodos { [weak self] result in
                switch result {
                case .success(let tasks):
                    DispatchQueue.main.async {
                        self?.coreManager.saveApiTasks(tasks)  
                        self?.presenter?.reloadData()
                        
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
