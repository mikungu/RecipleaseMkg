//
//  TestCoreDataFavorite.swift
//  RecipleaseMkgTests
//
//  Created by Mikungu Giresse on 29/03/23.
//

import Foundation

import CoreData
@testable import RecipleaseMkg

class TestCoreDataFavorite {
    // MARK: -Core Data Stack
    
    static let modelName = "FavoritesRecipesCoreData"
    static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var testContainer : NSPersistentContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: TestCoreDataFavorite.modelName, managedObjectModel: TestCoreDataFavorite.model)

        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    static var testContainer: NSPersistentContainer {
        return TestCoreDataFavorite().testContainer
    }

    static var testContext : NSManagedObjectContext {
        return testContainer.viewContext
    }
}

