//
//  ViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

class TodosViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let coreManager = CoreDataManager.shared
    
//    private let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    
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
        getTasks()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Todos"
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createNewTask))
    }
    
    @objc private func createNewTask() {
//        navigationController?.pushViewController(TaskViewController(), animated: true)
        coreManager.createTask(title: "Title", text: "")
        tableView.reloadData()
    }
    
    private func getTasks() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            networkManager.getTodos { [weak self] result in
                switch result {
                case .success(let tasks):
                    DispatchQueue.main.async {
                        self?.coreManager.saveApiTasks(tasks)
                        self?.tableView.reloadData()
                        
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
}

extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreManager.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = coreManager.tasks[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = task.title
        config.secondaryText = task.date?.formateDate()
        config.image = UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circlebadge")
        cell.contentConfiguration = config
        
        return cell
    }
}

extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = coreManager.tasks[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreManager.tasks[indexPath.row].deleteTask()
            coreManager.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
