//
//  TaskModuleBuilder.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

final class TaskModuleBuilder {
    static func buildModule(task: Task?) -> TaskViewController {
        let view = TaskViewController()
        let interactor = TaskInteractor(task: task)
        let router = TaskRouter()
        let presenter = TaskPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
}
