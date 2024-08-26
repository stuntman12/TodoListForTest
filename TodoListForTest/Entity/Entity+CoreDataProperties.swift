//
//  Entity+CoreDataProperties.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var todo: String
    @NSManaged public var completed: Bool

}

extension Entity : Identifiable {}

