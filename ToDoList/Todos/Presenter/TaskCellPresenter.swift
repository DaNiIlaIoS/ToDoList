//
//  TaskCellPresenter.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 29.08.2024.
//

import Foundation

protocol TaskCellPresenterProtocol: AnyObject {
    func configureCell(taskData: Task)
    func toggleCompletion()
}

final class TaskCellPresenter: TaskCellPresenterProtocol {
    weak var view: TaskCellViewProtocol?
    var interactor: TaskCellInteractorProtocol

    init(view: TaskCellViewProtocol?, interactor: TaskCellInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    func configureCell(taskData: Task) {
        view?.configureCell(title: taskData.title, text: taskData.text, isCompleted: taskData.isCompleted, date: taskData.date)
    }
    
    func toggleCompletion() {
        interactor.toggleCompletion()
    }
}
