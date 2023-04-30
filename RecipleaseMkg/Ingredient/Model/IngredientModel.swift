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
    
    public static let shared = IngredientModel (context: CoreDataStackIngredient.viewContext)
    
    let IngredientContext: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.IngredientContext = context
    }
    
    //MARK: - Repository
    func getIngredient (callback: @escaping ([Ingredients]) -> Void) {
        
        let request : NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do {
            let ingredients = try IngredientContext.fetch(request)
            callback(ingredients)
        } catch {
            callback([])
        }
    }
    
    func saveIngredient (named name: String, callback: @escaping ([Ingredients]) -> Void) {
        
        let ingredient = Ingredients(context: IngredientContext)
        ingredient.name = name
        do {
            try IngredientContext.save()
            callback([ingredient])
        } catch {
            print("We were unable to save \(name)")
        }
    }
    
    func deleteIngredient (callback: (([Ingredients]) -> Void)?) {
        
        let request : NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do {
            let ingredients = try IngredientContext.fetch(request)
            for objetToDelete in ingredients {
                IngredientContext.delete (objetToDelete)
            }
            callback?(ingredients)
        } catch {
            callback?([])
        }
        
        do {
            try IngredientContext.save()
        } catch {
            print("We were unable to save")
        }
    }
    
}

