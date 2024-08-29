//
//  TodosModeluBuilder.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import UIKit

final class TodosModuleBuilder {
    static func buildModule() -> TodosViewController {
        let view = TodosViewController()
        let interactor = TodosInteractor()
        let router = TodosRouter()
        let presenter = TodosPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
}
