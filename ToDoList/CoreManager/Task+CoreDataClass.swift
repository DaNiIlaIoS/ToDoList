//
//  Task+CoreDataClass.swift
//  ToDoList
//
//  Created by Даниил Сивожелезов on 28.08.2024.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

}

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var text: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var date: Date?

    
}

extension Task : Identifiable {
    func toggleCompleted() {
        self.isCompleted.toggle()
        
        do {
            try managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateTask(title: String, text: String?) {
        self.title = title
        self.text = text
        
        do {
            try managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteTask() {
        managedObjectContext?.delete(self)
        
        do {
            try managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
