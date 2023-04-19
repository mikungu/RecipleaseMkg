//
//  CoreDataStackIngrTest.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 30/03/23.
//

import Foundation

import CoreData

@testable import RecipleaseMkg

class CoreDataStackIngrTest {
    static let modelName = "CoreDataRecherche"
    static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var testContainer : NSPersistentContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: CoreDataStackIngrTest.modelName, managedObjectModel: CoreDataStackIngrTest.model)

        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    static var testContainer: NSPersistentContainer {
        return CoreDataStackIngrTest().testContainer
    }

    static var testContext : NSManagedObjectContext {
        return testContainer.viewContext
    }

}
