//
//  ViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

class TodosViewController: UIViewController {
    private let networkManager = NetworkManager()
    private var todos: [Task] = []
    // MARK: - GUI Variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getTodos()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Todos"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createNewTask))
    }
    
    @objc private func createNewTask() {
        
    }
    
    private func getTodos() {
        networkManager.getTodos { [weak self] result in
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self?.todos = todos
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = todos[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = task.todo
        config.image = UIImage(systemName: task.completed ? "checkmark.circle.fill" : "circlebadge")
        cell.contentConfiguration = config
        
        return cell
    }
}

extension TodosViewController: UITableViewDelegate {
    
}
