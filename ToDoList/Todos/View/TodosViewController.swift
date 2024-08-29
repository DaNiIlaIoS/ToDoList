//
//  ViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

protocol TodosViewProtocol: AnyObject {
    func reloadData()
}

final class TodosViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        return tableView
    }()
    
    // MARK: - Properties
    var presenter: TodosPresenterProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Todos"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createNewTask))
    }
    
    @objc private func createNewTask() {
        presenter?.showTaskVC(task: nil)
    }
}

extension TodosViewController: TodosViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
}

extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.didFetchTasks().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else { return UITableViewCell() }
        if let task = presenter?.didFetchTasks()[indexPath.row] {
            
            let interactor = TaskCellInteractor(taskData: task)
            let presenter = TaskCellPresenter(view: cell, interactor: interactor)
            cell.presenter = presenter
            cell.delegate = self
            
            presenter.configureCell(taskData: task)
        }
        
        return cell
    }
}

extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = presenter?.didFetchTasks()[indexPath.row]
        presenter?.showTaskVC(task: task)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
