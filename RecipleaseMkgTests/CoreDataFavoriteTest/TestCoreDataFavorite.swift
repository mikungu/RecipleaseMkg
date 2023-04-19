//
//  TestCoreDataFavorite.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 29/03/23.
//

import Foundation

import CoreData
@testable import RecipleaseMkg

class TestCoreDataStack: CoreDataStackFavorite {
    override init() {
        super.init()
        
        // Creates an in-memory persistent store
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        // Creates an NSPersistentContainer instance, passing in the modelName and NSManageObjectModel stored in the CoreDataStack
        let container = NSPersistentContainer(
            name: CoreDataStackFavorite.modelName,
            managedObjectModel: CoreDataStackFavorite.model)
        
        // Assigns the in-memory persistent store to the container
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Overrides the storeContainer in CoreDataStack
        storeContainer = container
    }
}

