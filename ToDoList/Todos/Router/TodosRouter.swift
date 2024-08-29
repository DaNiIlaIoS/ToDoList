//
//  TodosRouter.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TodosRouterProtocol: AnyObject {
    func openTaskVC(task: Task?)
}

final class TodosRouter: TodosRouterProtocol {
    weak var view: TodosViewController?
    
    func openTaskVC(task: Task?) {
        let viewController = TaskModuleBuilder.buildModule(task: task)
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
