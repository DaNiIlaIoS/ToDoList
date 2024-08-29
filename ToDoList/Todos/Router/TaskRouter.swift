//
//  TaskRouter.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TaskRouterProtocol: AnyObject {
    func popVC()
}

final class TaskRouter: TaskRouterProtocol {
    weak var view: TaskViewController?
    
    func popVC() {
        view?.navigationController?.popViewController(animated: true)
    }
}
