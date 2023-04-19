//
//  IngredientModel.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import Foundation
import CoreData

final class IngredientModel {
    
    
    //MARK: - Properties
   // private let coreDataStackIngr: CoreDataStack
    
    public static let shared = IngredientModel (context: CoreDataStackIngredient.viewContext)
    
    let favContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.favContext = context
    }
    
    
    
    //MARK: - Repository
    func getIngredient (callback: @escaping ([Ingredients]) -> Void) {

        let request : NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do {
            let ingredients = try favContext.fetch(request)
            callback(ingredients)
        } catch {
            callback([])
        }
    }
    
    func saveIngredient (named name: String, callback: @escaping ([Ingredients]) -> Void) {
       
        let ingredient = Ingredients(context: favContext)
        ingredient.name = name
        do {
            try favContext.save()
            callback([ingredient])
        } catch {
            print("We were unable to save \(name)")
        }
    }
    
    func deleteIngredient (callback: (([Ingredients]) -> Void)?) {
        
        let request : NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do {
            let ingredients = try favContext.fetch(request)
            for objetToDelete in ingredients {
                favContext.delete (objetToDelete)
            }
            callback?(ingredients)
        } catch {
            callback?([])
        }
        
        do {
            try favContext.save()
        } catch {
            print("We were unable to save")
        }
    }
    
}

