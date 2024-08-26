//
//  CoreDataManager.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation
import CoreData

protocol ICoreDataManager {
    func fetchItem() -> [Entity]
    func fetchItemId(id: Int)  -> Entity?
    func addItems(items: [Todo])
    func addItem(id: Int, completed: Bool, todo: String)
    func deleteAll()
    func deleteitem(id: Int)
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
            dump("Ошибка")
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
            dump("Ошибка")
            return
        }
        objects.forEach { item in
            persistentContainer.viewContext.delete(item)
            dump("Успешно")
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
            dump("Ошибка")
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
            dump("Ошибка")
            return
        }
        
        if let entity = objects.first(where: { $0.id == id }) {
            persistentContainer.viewContext.delete(entity)
            self.saveContext()
        }
    }
}
