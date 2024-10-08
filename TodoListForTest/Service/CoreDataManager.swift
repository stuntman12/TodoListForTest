//
//  CoreDataManager.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation
import CoreData

protocol ICoreDataManager {
    // Load all
    func fetchItem() -> [Entity]
    // Load one item
    func fetchItemId(id: Int)  -> Entity?
    // Add items
    func addItems(items: [Todo])
    // Add one items
    func addItem(id: Int, completed: Bool, todo: String)
    // Delete all
    func deleteAll()
    // Delete item by id
    func deleteitem(id: Int)
    // Update item
    func updateItem(item: Todo, todo: String, completed: Bool)
}

final class CoreDataManager: ICoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoListForTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext () {
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
    
    func fetchItem() -> [Entity] {
        let request = Entity.fetchRequest()
        guard let objects = try? persistentContainer.viewContext.fetch(request) else {
            return []
        }
        self.saveContext()
        return objects
    }
    
    func addItem(id: Int, completed: Bool, todo: String) {
        let entity = Entity(context: persistentContainer.viewContext)
        entity.id = Int64(id)
        entity.completed = completed
        entity.todo = todo
        persistentContainer.viewContext.insert(entity)
        self.saveContext()
    }
    
    
    func addItems(items: [Todo]) {
        items.forEach { todo in
            self.addItem(id: todo.id, completed: todo.completed, todo: todo.todo)
        }
    }
    
    func deleteAll() {
        let request = Entity.fetchRequest()
        guard let objects = try? persistentContainer.viewContext.fetch(request) else {
            return
        }
        objects.forEach { item in
            persistentContainer.viewContext.delete(item)
        }
        self.saveContext()
    }
    
    func fetchItemId(id: Int) -> Entity? {
        let entity = self.fetchItem()
        return entity.first { $0.id == id }
    }
    
    func updateItem(item: Todo, todo: String, completed: Bool) {
        let request = Entity.fetchRequest()
        guard let objects = try? persistentContainer.viewContext.fetch(request) else {
            return
        }
        
        let entity = objects.first { $0.id == item.id }
        
        entity?.todo = todo
        entity?.completed = completed
        
        self.saveContext()
        
    }
    
    func deleteitem(id: Int) {
        let request = Entity.fetchRequest()
        guard let objects = try? persistentContainer.viewContext.fetch(request) else {
            return
        }
        
        if let entity = objects.first(where: { $0.id == id }) {
            persistentContainer.viewContext.delete(entity)
            self.saveContext()
        }
    }
}
