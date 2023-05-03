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
    var coreData = "CoreDataRecherche"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: coreData)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

class CoreDataGenericService<T: NSManagedObject> {

    let ingredientContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.ingredientContext = context
    }
   
    // create Object
    func createObject () -> T {
        return T(context: ingredientContext)
    }
    // get Object
    func getObject () -> [T]{
        let request = T.fetchRequest()
        do {
            let results = try ingredientContext.fetch(request)
            return results as! [T]
        } catch let error {
            print ("Error fetching objects: \(error)")
            return []
        }
    }
    // MARK: -Core Data Saving Support
    // save object
    func save () {
        if ingredientContext.hasChanges {
            do {
                try ingredientContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // delete object
    func deleteObject() {
        let request = T.fetchRequest()
        do {
            let ingredients = try ingredientContext.fetch(request)
            for objectToDelete in ingredients {
                ingredientContext.delete(objectToDelete as! NSManagedObject)
            }
        } catch let error {
            print ("Error fetching objects: \(error)")
        }
        save()
    }
}


