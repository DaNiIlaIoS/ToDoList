//
//  ViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

class TodosViewController: UIViewController {
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
    private let networkManager = NetworkManager()
    private let coreManager = CoreDataManager.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getTasks()
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
        navigationController?.pushViewController(TaskViewController(), animated: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else { return UITableViewCell() }
        let task = coreManager.tasks[indexPath.row]
        
        cell.configureCell(task: task)
        cell.toggleCompletion = {
            task.toggleCompleted()
            tableView.reloadData()
        }
        
        return cell
    }
}

extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = coreManager.tasks[indexPath.row]
        let taskVC = TaskViewController()
        taskVC.task = task
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coreManager.tasks[indexPath.row].deleteTask()
            coreManager.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
}
