//
//  CoreDataStack.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import Foundation
import CoreData

class CoreDataStackIngredient {
    static let sharedInstance = CoreDataStackIngredient()
    
    // MARK: - CORE DATA STACK

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataRecherche")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static var persistentContainer: NSPersistentContainer {
        return CoreDataStackIngredient.sharedInstance.persistentContainer
    }

    static var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - CORE DATA SAVING SUPPORT
    
    func saveContext () {
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
}
