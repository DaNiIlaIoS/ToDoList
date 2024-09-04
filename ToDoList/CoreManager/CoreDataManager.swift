//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 28.08.2024.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    var tasks: [Task] { get set }
    
    func fetchTask()
    func saveApiTasks(_ apiTasks: [ApiTask])
    func createTask(title: String, text: String?)
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var tasks: [Task] = []
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveApiTasks(_ apiTasks: [ApiTask]) {
        for apiTask in apiTasks {
            let task = Task(context: context)
            task.id = String(apiTask.id)
            task.title = apiTask.todo
            task.text = apiTask.description ?? ""
            task.isCompleted = apiTask.completed
            task.date = apiTask.date ?? Date()
        }
        
        saveContext()
        fetchTask() // Обновление массива tasks после сохранения
    }
    
    func createTask(title: String, text: String?) {
        let task = Task(context: context)
        task.id = UUID().uuidString
        task.title = title
        task.text = text
        task.date = Date()
        task.isCompleted = false
        
        saveContext()
        fetchTask()
    }
    
    func fetchTask() {
        let request = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        if let task = try? context.fetch(request) {
            tasks = task
        }
    }
}
