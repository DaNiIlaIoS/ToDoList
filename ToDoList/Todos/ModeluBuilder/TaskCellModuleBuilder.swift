//
//  TaskCellModuleBuilder.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

final class TaskCellModuleBuilder {
    static func buildModule(task: Task) -> TaskCell {
        let view = TaskCell()
        let interactor = TaskCellInteractor(taskData: task)
        let presenter = TaskCellPresenter(view: view, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        
        return view
    }
}
