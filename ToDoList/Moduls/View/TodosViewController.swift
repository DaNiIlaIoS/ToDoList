//
//  ViewController.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 27.08.2024.
//

import UIKit

protocol TodosViewProtocol: AnyObject {
    func reloadData()
    func updateBottomBarCount()
}

final class TodosViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        return tableView
    }()
    
    // MARK: - Properties
    private lazy var bottomBar = BottomBarView()
    var presenter: TodosPresenterProtocol?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.fetchTasks()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        
//        hideKeyboardWhenTapped()
        setupConstraints()
        setupBottomBar()
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupBottomBar() {
        bottomBar.addButton.addTarget(self, action: #selector(createNewTask), for: .touchUpInside)
    }
    
    // MARK: - Actions    
    @objc private func createNewTask() {
        presenter?.showTaskVC(task: nil)
    }
}

// MARK: - TodosViewProtocol
extension TodosViewController: TodosViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateBottomBarCount() {
        let count = presenter?.allTasks.count ?? 0
        bottomBar.updateCount(count)
    }
}

// MARK: - UITableViewDataSource
extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.filteredTasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else { return UITableViewCell() }
        if let task = presenter?.task(at: indexPath.row) {
            
            let interactor = TaskCellInteractor(taskData: task)
            let presenter = TaskCellPresenter(view: cell, interactor: interactor)
            cell.presenter = presenter
            cell.delegate = self
            
            presenter.configureCell(taskData: task)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = presenter?.task(at: indexPath.row)
        presenter?.showTaskVC(task: task)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            presenter?.fetchTasks()
        }
    }
    
    // Реализация Context Menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let task = presenter?.allTasks[indexPath.row] else { return UIContextMenuConfiguration() }
        
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            // Создание меню
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.presenter?.showTaskVC(task: task)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let title = task.title, let text = task.text else { return }
                let activityVC = UIActivityViewController(activityItems: ["\(title)\n\(text)"], applicationActivities: nil)
                self?.present(activityVC, animated: true, completion: nil)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.presenter?.deleteTask(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self?.presenter?.fetchTasks()
            }
            
            return UIMenu(title: "", children: [shareAction, editAction, deleteAction])
        }
    }
}

// MARK: - UISearchBarDelegate
extension TodosViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTasks(with: searchText)
    }
}
