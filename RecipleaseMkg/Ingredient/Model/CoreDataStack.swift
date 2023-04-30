//
//  CoreDataStack.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    static let sharedInstance = CoreDataStack()
    
    // MARK: -Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataRecherche")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

class CoreDataGenericService<T: NSManagedObject> {
    let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
    
    // create Object
    func createObject () -> T {
        return T(context: context)
    }
    // get Object
    func getObject () -> [T]{
        let request = T.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results as! [T]
        } catch let error {
            print ("Error fetching objects: \(error)")
            return []
        }
    }
    // MARK: -Core Data Saving Support
    
    func save () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteObject() {
        let request = T.fetchRequest()
        do {
            let ingredients = try context.fetch(request)
            for objectToDelete in ingredients {
                context.delete(objectToDelete as! NSManagedObject)
            }
        } catch let error {
            print ("Error fetching objects: \(error)")
        }
        save()
    }
}

class IngredientModel1 {
    let coreDataService = CoreDataGenericService<Ingredients>()
    
    func saveIngredient (named name: String, completion: @escaping ([Ingredients]) -> Void) {
        let ingredient = coreDataService.createObject()
        ingredient.name = name
        coreDataService.save()
        completion ([ingredient])
    }
    
    func getIngredient (completion: @escaping ([Ingredients]) -> Void) {
        let ingredients = coreDataService.getObject()
        completion (ingredients)
        
    }
    
    func deleteIngredient (completion: @escaping ([Ingredients]) -> Void) {
        coreDataService.deleteObject()
    }
}
