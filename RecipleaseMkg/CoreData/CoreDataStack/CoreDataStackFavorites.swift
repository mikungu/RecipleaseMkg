//
//  CoreDataStackFavorites.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 03/04/23.
//

import Foundation

import CoreData

import UIKit

class CoreDataStackFav {
    static let sharedInstance = CoreDataStackFav()
    
    // MARK: -Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoritesRecipesCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

class CoreDataGenericService2<T: NSManagedObject> {
    
    let favoriteContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.favoriteContext = context
    }
   
    
    // create Object
    func createObject () -> T {
        return T(context: favoriteContext)
    }
    // get Object
    func getObject () -> [T]{
        let request = T.fetchRequest()
        do {
            let results = try favoriteContext.fetch(request)
            return results as! [T]
        } catch let error {
            print ("Error fetching objects: \(error)")
            return []
        }
    }
    
    func checkObject (recipeName: String) -> [T] {
        let request = T.fetchRequest()
        request.predicate = NSPredicate(format:"label = %@", recipeName)
        do {
            let results = try favoriteContext.fetch(request)
            return results as! [T]
        } catch let error {
            print ("Error fetching objects: \(error)")
            return []
        }
        
    }
    // MARK: -Core Data Saving Support
    
    func save () {
            do {
                try favoriteContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
    }
    
    
    func deleteObject(recipeName: String) {
        let request = T.fetchRequest()
        request.predicate = NSPredicate (format: "label = %@", recipeName)
        do {
            let ingredients = try favoriteContext.fetch(request)
            for objectToDelete in ingredients {
                favoriteContext.delete(objectToDelete as! NSManagedObject)
            }
        } catch let error {
            print ("Error fetching objects: \(error)")
        }
        save()
    }
}



