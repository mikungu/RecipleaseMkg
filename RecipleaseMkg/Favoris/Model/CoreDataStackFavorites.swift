//
//  CoreDataStackFavorites.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 03/04/23.
//

import Foundation

import CoreData
    
open class CoreDataStackFavorite {
        public static let modelName = "FavoritesRecipesCoreData"
        
        public static let model: NSManagedObjectModel = {
            guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else { return NSManagedObjectModel() }
            guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else { return NSManagedObjectModel() }
            return managedObjectModel
        }()
        
        public init() {
        }
        
        public lazy var mainContext: NSManagedObjectContext = {
            return storeContainer.viewContext
        }()
        
        public lazy var storeContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: CoreDataStackFavorite.modelName, managedObjectModel: CoreDataStackFavorite.model)
            container.loadPersistentStores { _, error in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        
        public func newDerivedContext() -> NSManagedObjectContext {
            let context = storeContainer.newBackgroundContext()
            return context
        }
        
        public func saveContext() {
            saveContext(mainContext)
        }
        
        public func saveContext(_ context: NSManagedObjectContext) {
            if context != mainContext {
                saveDerivedContext(context)
                return
            }
            
            context.perform {
                do {
                    try context.save()
                } catch let error as NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
        
        public func saveDerivedContext(_ context: NSManagedObjectContext) {
            context.perform {
                do {
                    try context.save()
                } catch let error as NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
                
                self.saveContext(self.mainContext)
            }
        }
    }
